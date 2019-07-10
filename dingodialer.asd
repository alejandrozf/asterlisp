;;;; dingodialer.asd

(asdf:defsystem #:dingodialer
  :description "Describe dingodialer here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  ;; evaluate the use of :lparalell, :safe-queue, :babel, :cl-mpi, :ceramic
  :depends-on (:drakma :usocket :bordeaux-threads)
  :components ((:file "package")
               (:file "dingodialer")))
