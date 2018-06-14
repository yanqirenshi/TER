(in-package :ter)

(defclass port-ter (shinra:shin rsc point) ())

(defmethod jojo:%to-json ((obj port-ter))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    ;; point
    (jojo:write-key-value "x" (slot-value obj 'x))
    (jojo:write-key-value "y" (slot-value obj 'y))
    (jojo:write-key-value "z" (slot-value obj 'z))
    (jojo:write-key-value "_class" "port")))
