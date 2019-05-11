;;;; dingodialer.asd

(asdf:defsystem #:dingodialer
  :description "Describe dingodialer here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (:drakma)
  :components ((:file "package")
               (:file "dingodialer")))
