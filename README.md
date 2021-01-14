# Asterlisp
### _Alejandro Zamora <ale2014.zamora@gmail.com>_

Common Lisp client to Asterisk AMI protocol.

Tested on:
  - SBCL (1.5.4, 2.0.0)
    Clozure CL 1.12
  - Asterisk 16.3.0
  - Ubuntu 18.04
  - x86_64

## Quickstart

- Setup Asterisk

  *You will need docker-compose installed*

  $ cd docker-asterisk

  $ docker-compose up -d

  $ sh containers-cp-conf.sh

- Load library

  * You will need quicklisp installed for load ultralisp distribution

  On Lisp REPL:

  CL-USER> (ql-dist:install-dist "http://dist.ultralisp.org/" :prompt nil)

  CL-USER> (ql:quickload :asterlisp)

  CL-USER> (in-package :asterlisp)

  ASTERLISP> (setf manager1 (make-instance 'manager))

  ASTERLISP> (setf (gethash "Hangup" (manager->callbacks manager1))
                   (lambda () (disconnect manager1) (print "Hangup detected from callback" test-output)))

  ASTERLISP> (connect manager1 "172.46.0.2" 5038)

  ASTERLISP> (login manager1 "omnileadsami" "5_MeO_DMT")

  ASTERLISP> (originate manager1 "Local/351111111@from-dialer/n" "s"
                        :context "call-answered" :PRIORITY "1" :variables '(:a 1 :b 2))

  NIL

  "Hangup detected from callback"

  ASTERLISP>

## License

MIT
