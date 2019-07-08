;;;; package.lisp

(defpackage #:dingodialer
  (:use #:cl)
  (:export
   :manager :connect :login :close :send-action :command :originate))
