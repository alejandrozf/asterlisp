;; Sockets AMI TCP snippet working!!
(setf *socket* (usocket:socket-connect "asterisk-dialer" 5038))

(setf *stream* (usocket:socket-stream *socket*))

(read-line *stream*)

(setf *crlf* (format nil "~C~C" #\Return #\Newline))

(setf *login* (format nil "Action: Login~aUsername: omnileadsami~aSecret: 5_MeO_DMT~a~a"
                      *crlf* *crlf* *crlf* *crlf*))

(format *stream* *login*)

(force-output *stream*)
