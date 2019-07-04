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

(defmethod send-action ((self manager) name &rest params &key &allow-other-keys)
  (setf *stream* (usocket:socket-stream (manager->socket self)))
  (setf action (format nil "Action: ~a~a" name *crlf*))
  (loop for (key value) on params by #'cddr :do
       (setf action (concatenate
                     'string action (format nil "~a: ~a~a" key value *crlf*))))
  (setf action (concatenate 'string action *crlf*))
  (format  *stream* action)
  (force-output *stream*))

(defmethod command ((self manager) command)
  (send-action self "Command" :command command))

(defmethod login ((self manager) username password &key)
  (send-action self "Login" :username username :secret password))

(defmethod logout ((self manager) &key)
  (setf (manager->connected self) nil)
  (send-action self "Logoff"))

;; (defmethod originate ((self manager) channel exten
;;                       &key (context "") (priority "") (timeout "") (caller-id "") (async nil) (earlymedia "false")
;;                         (account "") (variables '()))
;;   (macrolet ((generate-send-action ))
;;     )
;;   (let ((params '(:channel channel :exten exten))
;;         (variables '()))
;;     (unless (equal context "") (nconc params `(:context context)))
;;     (unless (equal priority "") (nconc params `(:priority priority)))
;;     (unless (equal timeout "") (nconc params `(:timeout timeout)))
;;     (unless (equal caller-id "") (nconc params `(:callerid caller-id)))
;;     (when async (nconc params `(:async "yes")))
;;     (unless earlymedia (nconc params `(:earlymedia earlymedia)))
;;     (loop for (key value) on variables :by #'cddr :do
;;          (nconc params variables)
;;     `(send-action self "Originate" ,@params)))
