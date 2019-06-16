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
