;;;; dingodialer.lisp

(in-package #:dingodialer)

(setf login-parameters '(("action" . "login")
                         ("username" . "omnisup")
                         ("secret" . "Sup3rst1c10n")))
(setf base-url "http://172.18.0.2:7088/mxml")

(setf command-parameters '(("action" . "command")
                           ("command" . "database show")))

(defun asterisk-db-show ()
  (let ((cookie-jar (make-instance 'drakma:cookie-jar)))
    (drakma:http-request base-url :method :post :parameters login-parameters :cookie-jar cookie-jar)
    (drakma:http-request base-url :method :post :parameters command-parameters :cookie-jar cookie-jar)))
