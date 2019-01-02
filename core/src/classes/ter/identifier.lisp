(in-package :ter)

(defclass identifier (shinra:shin) ())

(defclass identifier-instance (shinra:shin rsc)
  ((data-type :accessor data-type :initarg :data-type :initform nil)))

(defmethod jojo:%to-json ((obj identifier-instance))
  (jojo:with-object
    (jojo:write-key-value "_id"         (slot-value obj 'up:%id))
    (jojo:write-key-value "code"        (slot-value obj 'code))
    (jojo:write-key-value "name"        (slot-value obj 'name))
    (jojo:write-key-value "data-type"   (slot-value obj 'data-type))
    (jojo:write-key-value "description" (slot-value obj 'description))
    (jojo:write-key-value "_class"      "IDENTIFIER-INSTANCE")))
