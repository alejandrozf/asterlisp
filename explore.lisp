;; Sockets AMI TCP snippet working!!
(ql:quickload '(:usocket :bordeaux-threads))

;; evaluate the use of :lparalell, :safe-queue, :babel, :cl-mpi


(defparameter *crlf* (format nil "~C~C" #\return #\newline))

(defclass manager ()
  ((socket :accessor manager->socket :initform nil)
   (connected :accessor manager->connected :initform nil)
   (response-queue :accessor manager->response-queue
                   :initform '())
   (callbacks :accessor manager->callbacks
              :initform (make-hash-table))
   (response-thread :accessor manager->response-thread
                    :initform nil)))

(defmethod receive-data ((self manager))
  (setf *stream* (usocket:socket-stream (manager->socket self)))
  (loop :when (manager->connected self)
     :do (setf (manager->response-queue self)
               (append (manager->response-queue self) (list (read-line *stream*))))))

(defmethod connect ((self manager) host port &key)
  (setf (manager->socket self) (usocket:socket-connect host port))
  (setf (manager->connected self) t)
  (setf (manager->response-thread self) (bt:make-thread (lambda () (receive-data self)))))


(defmethod close ((self manager) &key abort)
  (setf (manager->connected self) nil)
  (usocket:socket-close (manager->socket self))
  )

(defmethod send-action ((self manager) name params &key)
  (setf *stream* (usocket:socket-stream (manager->socket self)))
  (setf action (format nil "Action: ~a~a" name *crlf*))
  (maphash (lambda (key value)
             (setf action (concatenate 'string action (format nil "~a: ~a~a" key value *crlf*))))
             params)
  (setf action (concatenate 'string action *crlf*))
  (format  *stream* action)
  (force-output *stream*))

(defmethod command ((self manager) params &key)
  (send-action self "Command" params))

(defmethod login ((self manager) username password &key)
  (let ((params (make-hash-table)))
    (setf (gethash "Username" params) username)
    (setf (gethash "Secret" params) password)
    (send-action self "Login" params)))
