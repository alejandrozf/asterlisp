;; This file is an example for using Asterlisp
;; for retrieve the available agents using the AMI action "QueueSummary",
;; parsing the output and storing in a hash table


(ql:quickload :asterlisp)

(in-package :asterlisp)

(defparameter *asterisk-ami-host* "172.20.0.2")
(defparameter *asterisk-ami-port* 5038)
(defparameter *asterisk-ami-username* "omnileadsami")
(defparameter *asterisk-ami-password* "5_MeO_DMT")

(defparameter *manager* (make-instance 'manager))

(defun get-available-agents-aux (queue-summary-list)
  "Get asterisk queues in a more readable format"
  (let ((current-queue nil)
        (queue-stats (make-hash-table :test 'equal))
        (scanner-queue (ppcre:create-scanner "^Queue: (.*)$"))
        (scanner-available (ppcre:create-scanner "^Available: (.*)$")))
    (dolist (data-line queue-summary-list)
      (let ((match-queue (nth-value 1 (ppcre:scan-to-strings scanner-queue data-line)))
            (match-available (nth-value 1 (ppcre:scan-to-strings scanner-available data-line))))
        (cond (match-queue
                (setf current-queue (aref match-queue 0)))
              (match-available
                 (setf (gethash current-queue queue-stats) (aref match-available 0)))
              (t nil))))
    queue-stats))

(defun get-available-agents ()
  (connect *manager* *asterisk-ami-host* *asterisk-ami-port*)
  (login *manager* *asterisk-ami-username* *asterisk-ami-password*)
  (send-action *manager* "QueueSummary")
  ;; waits until Asterisk send all event data
  (sleep 1)
  (setf queue-summary-list (manager->response-queue *manager*))
  (setf queue-stats (get-available-agents-aux queue-summary-list))
  (logout *manager*)
  queue-stats)
