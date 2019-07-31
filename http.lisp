;; asterlisp old initial code, only here for historical reasons
;; it uses HTTP to make AMI calls, changed for use sockets for convenience
;; events logs access

(in-package #:asterlisp)

(setf *login-parameters* '(("action" . "login")
                           ("username" . "omnileadsami")
                           ("secret" . "5_MeO_DMT")))
(setf *base-url* "http://172.46.0.2:8088/asterisk/mxml")

(setf *command-parameters* '(("action" . "command")
                             ("command" . "database show")))

(defun asterisk-db-show ()
  (let ((cookie-jar (make-instance 'drakma:cookie-jar)))
    (drakma:http-request *base-url* :method :post :parameters *login-parameters* :cookie-jar cookie-jar)
    (drakma:http-request *base-url* :method :post :parameters *command-parameters* :cookie-jar cookie-jar)))


(defun asterisk-originate (phone)
  (let* ((cookie-jar (make-instance 'drakma:cookie-jar))
         (channel (format nil "Local/~a@from-dialer/n" phone))
         (*command-parameters* `(("action" . "originate")
                                 ("exten" . "s")
                                 ("channel" . ,channel)
                                 ("context" . "call-answered")
                                 ("priority" . "1"))))
    (drakma:http-request *base-url* :method :post :parameters *login-parameters* :cookie-jar cookie-jar)
    (drakma:http-request *base-url* :method :post :parameters *command-parameters* :cookie-jar cookie-jar)
    ))
