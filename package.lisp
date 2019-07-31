;;;; package.lisp

(defpackage #:asterlisp
  (:use #:cl)
  (:export
   :manager :connect :login :close :send-action :command :originate))
