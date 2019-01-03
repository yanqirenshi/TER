(in-package :ter)

(defclass correspondence (entity) ()
  (:documentation "対応表"))

(defmethod jojo:%to-json ((obj correspondence))
  (jojo:with-object
    (jojo:write-key-value "_id"      (slot-value obj 'up:%id))
    (jojo:write-key-value "code"     (slot-value obj 'code))
    (jojo:write-key-value "name"     (slot-value obj 'name))
    (jojo:write-key-value "position" (slot-value obj 'location))
    (jojo:write-key-value "size"     (slot-value obj 'size))
    (jojo:write-key-value "_class" "CORRESPONDENCE")))
