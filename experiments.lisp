(ql:quickload :safe-queue :bordeaux-threads)


(defconstant +eol+ (format nil "~a~a" #\return #\newline))


(defclass message ()
  ((response :initarg :response)
   (data :initarg :data
         :initform "")
   (headers :initarg :headers
            :initform (make-hash-table)))
  (:documentation "A manager interface message"))

(defmethod initialize-instance :after ((obj message) &key response data headers)
  (setf (slot-value obj 'response) response)
  ;; (parse response)
  ;; pending some validation Asterisk parse specific code ...
  )

;; (defmethod parse ((response message))
;;   )

;; (defmethod has-headers ((response message) hname)
;;   )

;; (defmethod get-header (args)
;;   )

;; __getitem__, __repr__,


(defclass event ()
  ((message :initarg :message)
   data
   headers
   name)
  (:documentation "Manager interface events"))

(defmethod initialize-instance ((obj event) &key message)
  (setf (slot-value obj 'message) message)
  (setf (slot-value obj 'data) (slot-value message 'data))
  (setf (slot-value obj 'headers) (slot-value message 'headers))

  ;; a litle more code pending

  ;; has_header, get_header, __getitem__, __repr__, get_action

  )


(defclass manager ()
  ((sock :accessor manager->sock :initform nil)
   (title :accessor manager->title :initform nil)
   (connected :accessor manager->connected)
   (running :accessor manager->running)
   (hostname :accessor manager->hostname)
   (message-queue :accessor manager->message-queue)
   (response-queue :accessor manager->response-queue)
   (event-queue :accessor manager->event-queue)
   (event-callbacks :accessor manager->event-callbacks
                    :initform (make-hash-table))
   (reswaiting :accessor manager->reswaiting
               :initform '())
   (seqlock :accessor manager->seqlock)
   (seq :accessor manager->seq :initform 0)
   (message-thread :accessor manager->message-thread)
   (event-dispatch-thread :accessor manager->event-dispatch-thread)))

(defmethod initialize-instance :after ((obj manager) &key)
  ;; self._connected = threading.Event()
  ;; self._running = threading.Event()
  (setf (manager->hostname manager) (machine-instance))
  (setf (manager->message-queue manager) (safe-queue:make-queue))
  (setf (manager->response-queue manager) (safe-queue:make-queue))
  (setf (manager->event-queue manager) (safe-queue:make-queue))

  (setf (manager->seqlock manager) (bt:make-lock))

  ;; self.message_thread = threading.Thread(target=self.message_loop)
  ;; self.event_dispatch_thread = threading.Thread(target=self.event_dispatch)
  ;; self.message_thread.setDaemon(True)
  ;; self.event_dispatch_thread.setDaemon(True)

  )
