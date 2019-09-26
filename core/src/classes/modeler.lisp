(in-package :ter)

(defclass ghost-shadow (shinra:shin)
  ((ghost-id :accessor ghost-id :initarg :ghost-id :initform nil)))

(defclass modeler (shinra:shin)
  ((name :accessor name :initarg :name :initform nil)))

(defmethod jojo:%to-json ((obj modeler))
  (jojo:with-object
    (jojo:write-key-value "_id"    (slot-value obj 'up:%id))
    (jojo:write-key-value "name"   (or (slot-value obj 'name) :null))
    (jojo:write-key-value "_class" "MODELER")))
