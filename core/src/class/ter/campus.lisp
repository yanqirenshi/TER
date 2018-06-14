(in-package :ter)

(defclass campus (shinra:shin rsc)
  ((store-directory :accessor store-directory :initarg :store-directory :initform nil)))

(defmethod jojo:%to-json ((obj campus))
  (jojo:with-object
    (jojo:write-key-value "_id"             (slot-value obj 'up:%id))
    (jojo:write-key-value "code"            (slot-value obj 'code))
    (jojo:write-key-value "name"            (slot-value obj 'name))
    (jojo:write-key-value "description"     (slot-value obj 'description))
    (jojo:write-key-value "store-directory" (slot-value obj 'store-directory))
    (jojo:write-key-value "_class"          "CAMPUS")))
