;; Sockets AMI TCP snippet working!!
(ql:quickload '(:usocket :bordeaux-threads))

;; evaluate the use of :lparalell, :safe-queue, :babel, :cl-mpi


(defparameter *crlf* (format nil "~C~C" #\return #\newline))

(defclass manager ()
  ((socket :accessor manager->socket :initform nil)
   (connected :accessor manager->connected :iniform nil)
   (response-queue :accessor manager->response-queue)
   (callbacks :accessor manager->callbacks
              :initform (make-hash-table))
   (response-thread :accessor manager->message-thread
                    :initform '())))

(defmethod receive-data ((self manager))
  (setf *stream* (usocket:socket-stream (manager->socket self)))
  (loop :when (manager->connected self)
     :do (setf (manager->response-queue self)
               (append (manager->response-queue self) (read-line *stream*))))))

(defmethod connect ((self manager) host port)
  (setf (manager->socket self) (usocket:socket-connect host port))
  (setf (manager->connected self) t)
  (setf (manager->response-thread self) (bt:make-thread #'receive-data))


(defmethod close ((self manager))
  (setf (manager->connected self) nil)
  (usocket:socket-close (manager->socket self)))

(defmethod send-action ((self manager) name &key params)
  (setf *stream* (usocket:socket-stream (manager->socket)))
  (setf action (format nil "Action: ~a~a" name *crlf*))
  (maphash (lambda (key value)
             (setf action (concatenate 'string action (format nil "~a: ~a~a" key value *crlf*)))
             params))
  (concatenate 'string action *crlf*)
  (format  *stream* action)
  (force-output *stream*))

(defmethod login ((self manager)))

(defmethod command ((self manager)))
