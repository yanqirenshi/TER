(in-package :ter)

(defclass resource (entity) ())

(defmethod jojo:%to-json ((obj resource))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    ;; point
    (jojo:write-key-value "x" (slot-value obj 'x))
    (jojo:write-key-value "y" (slot-value obj 'y))
    (jojo:write-key-value "z" (slot-value obj 'z))
    ;; rect
    (jojo:write-key-value "w" (slot-value obj 'w))
    (jojo:write-key-value "h" (slot-value obj 'h))
    (jojo:write-key-value "_class" "RESOURCE")))
