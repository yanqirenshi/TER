(in-package :ter)

(defclass port-ter (shinra:shin rsc point)
  ((location :accessor location :initarg :location :initform 0.0
             :documentation "degree")))

(defmethod jojo:%to-json ((obj port-ter))
  (jojo:with-object
    (jojo:write-key-value "_id"      (slot-value obj 'up:%id))
    (jojo:write-key-value "position" (slot-value obj 'location))
    (jojo:write-key-value "_class"   "port")))
