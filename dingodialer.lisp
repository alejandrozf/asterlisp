;;;; dingodialer.lisp

(in-package #:dingodialer)

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


(defun asterisk-originate ()
  (let* ((cookie-jar (make-instance 'drakma:cookie-jar))
         (*command-parameters* '(("action" . "originate")
                                 ("exten" . "s")
                                 ("channel" . "Local/21123132@from-dialer/n")
                                 ("context" . "call-answered")
                                 ("priority" . "1"))))
    (drakma:http-request *base-url* :method :post :parameters *login-parameters* :cookie-jar cookie-jar)
    (drakma:http-request *base-url* :method :post :parameters *command-parameters* :cookie-jar cookie-jar)))
