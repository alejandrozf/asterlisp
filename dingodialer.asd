;;;; dingodialer.asd

(asdf:defsystem #:dingodialer
  :description "AMI client"
  :author "Alejandro Zamora Fonseca <ale2014.zamora@gmail.com>"
  :license  "GPLv3"
  :version "0.0.1"
  :serial t
  ;; evaluate the use of :lparalell, :safe-queue, :babel, :cl-mpi, :ceramic
  :depends-on (:drakma :usocket :bordeaux-threads)
  :components ((:file "package")
               (:file "dingodialer")))
