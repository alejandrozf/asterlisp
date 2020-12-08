;;;; asterlisp.asd

(asdf:defsystem #:asterlisp
  :description "AMI client"
  :author "Alejandro Zamora Fonseca <ale2014.zamora@gmail.com>"
  :license  "GPLv3"
  :version "0.0.1"
  :serial t
  ;; evaluate the use of :lparalell, :safe-queue, :babel, :cl-mpi, :ceramic
  :depends-on (:usocket :bordeaux-threads :log4cl)
  :components ((:file "package")
               (:file "asterlisp")))
