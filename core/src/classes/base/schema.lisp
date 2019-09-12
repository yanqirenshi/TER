(in-package :ter)

(defclass schema (shinra:shin rsc)
  ((store-directory :accessor store-directory :initarg :store-directory :initform nil)))

(defmethod jojo:%to-json ((obj schema))
  (jojo:with-object
    (jojo:write-key-value "_id"             (slot-value obj 'up:%id))
    (jojo:write-key-value "code"            (slot-value obj 'code))
    (jojo:write-key-value "name"            (or (slot-value obj 'name) ""))
    (jojo:write-key-value "description"     (or (slot-value obj 'description) ""))
    (jojo:write-key-value "store-directory" (if (slot-value obj 'store-directory)
                                                (princ-to-string (slot-value obj 'store-directory))
                                                :null))
    (jojo:write-key-value "_class"          "SCHEMA")))
