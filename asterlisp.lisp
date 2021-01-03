;;;; asterlisp.lisp

(in-package #:asterlisp)

;; TODO: parameterize log file (now is on /)
;change to :info to see messages
(log:config :daily "asterlisp.log" :off)

(defparameter *crlf* (format nil "~C~C" #\return #\newline))

(defparameter test-output *standard-output*) ;for debugging purposes

(defclass manager ()
  ((socket :accessor manager->socket :initform nil)
   (connected :accessor manager->connected :initform nil)
   (response-queue :accessor manager->response-queue
                   :initform '())
   (callbacks :accessor manager->callbacks
              :initform (make-hash-table :test 'equal))
   (response-thread :accessor manager->response-thread
                    :initform nil))
  (:documentation "Base class to access AMI specification"))

(defmethod receive-data ((self manager))
  "Reads events data from Asterisk"
  (flet ((dispatch-callback (event)
           (when event
             (let ((callback (gethash event (manager->callbacks self))))
               (when callback
                 (bt:make-thread callback)))))
         (get-event (data-line)
           (let* ((scanner (ppcre:create-scanner "^Event: (.*)$"))
                  (match (nth-value 1 (ppcre:scan-to-strings scanner data-line))))
             (if match (aref match 0)))))
    (setf *stream* (usocket:socket-stream (manager->socket self)))
    (loop :when (manager->connected self)
       :do (let ((data-line (handler-case (read-line *stream*)
                              ;; We lost socket connection to Asterisk server
                              (error (e)
                                (log:error "Can't read from Asterisk server")
                                (setf (manager->connected self) nil)))))
             (log:info "Trying to read data from Asterisk")
             (dispatch-callback (get-event data-line))
             (setf (manager->response-queue self)
                   (append (manager->response-queue self) (list data-line)))))))

(defmethod connect ((self manager) host port &key)
  "Connects to Asterisk server and start the receiving data thread"
  (setf (manager->socket self) (usocket:socket-connect host port))
  (setf (manager->connected self) t)
  (setf (manager->response-thread self) (bt:make-thread (lambda () (receive-data self)))))

(defmethod disconnect ((self manager) &key abort)
  "Closes connection to Asterisk server"
  (setf (manager->connected self) nil)
  (usocket:socket-close (manager->socket self))
  )

(defun process-variables (variables)
  (let ((result variables))
    (setf result (loop for (key value) on variables by #'cddr
                    :collect (format nil "~a=~a" key value)))
    (setf result (format nil "~{~A~^,~}" result))
    result))

(defmethod send-action ((self manager) name &rest params &key &allow-other-keys)
  "Sends an action to Asterisk"
  (setf *stream* (usocket:socket-stream (manager->socket self)))
  (setf action (format nil "Action: ~a~a" name *crlf*))
  (loop for (key value) on params by #'cddr :do
       (if (equal key :variable)
           (setf action (concatenate
                         'string action (format nil "~a: ~a~a" key (process-variables value)
                                                *crlf*)))
           (setf action (concatenate
                         'string action (format nil "~a: ~a~a" key value *crlf*)))))
  (setf action (concatenate 'string action *crlf*))
  (format *stream* action)
  (force-output *stream*))

(defmethod command ((self manager) command)
  "Sends a command to Asterisk"
  (send-action self "Command" :command command))

(defmethod login ((self manager) username password &key)
  "Sends the LOGIN command to Asterisk"
  (send-action self "Login" :username username :secret password))

(defmethod logout ((self manager) &key)
  "Sends the LOGOUT command to Asterisk"
  (setf (manager->connected self) nil)
  (send-action self "Logoff")
  (bt:destroy-thread (manager->response-thread self)))

(defmethod originate ((self manager) channel exten
                      &key (context "") (priority "") (timeout "") (application "") (data "")
                        (caller-id "") (async nil) (earlymedia "false") (account "")
                        (variables '()))
  "Sends the ORIGINATE command to Asterisk"
  (macrolet ((send-action-originate (manager channel exten context priority timeout application data
                                             caller-id async earlymedia account variables)
               (let ((params (list :channel channel :exten exten)))
                 (unless (equal context "") (nconc params `(:context ,context)))
                 (unless (equal priority "") (nconc params `(:priority ,priority)))
                 (unless (equal timeout "") (nconc params `(:timeout ,timeout)))
                 (unless (equal application "") (nconc params `(:application ,application)))
                 (unless (equal data "") (nconc params `(:data ,data)))
                 (unless (equal caller-id "") (nconc params `(:callerid ,caller-id)))
                 (when async (nconc params `(:async "yes")))
                 (unless earlymedia (nconc params `(:earlymedia ,earlymedia)))
                 (when variables (nconc params `(:variable ,variables)))
                 `(send-action ,manager "Originate" ,@params))))
  (send-action-originate self channel exten context priority timeout application data
                         caller-id async earlymedia account variables)))

;; Example:
;; (ql-dist:install-dist "http://dist.ultralisp.org/" :prompt nil)
;; (in-package :asterlisp)
;; (setf manager1 (make-instance 'manager))
;; (setf (gethash "Hangup" (manager->callbacks manager1)) (lambda () (print "Hangup detected from callback" test-output)))
;; (connect manager1 "172.46.0.2" 5038)
;; (login manager1 "omnileadsami" "5_MeO_DMT")
;; (originate manager1 "Local/351111111@from-dialer/n" "s" :context "call-answered" :PRIORITY "1")
;; (command manager1 "database show")
;; (logout manager1)
