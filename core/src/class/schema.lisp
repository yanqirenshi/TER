(in-package :ter)

(defclass schema (shinra:shin rsc) ())

(defmethod jojo:%to-json ((obj schema))
  (jojo:with-object
    (jojo:write-key-value "_id"         (slot-value obj 'up:%id))
    (jojo:write-key-value "code"        (slot-value obj 'code))
    (jojo:write-key-value "name"        (slot-value obj 'name))
    (jojo:write-key-value "description" (slot-value obj 'description))
    (jojo:write-key-value "_class" "SCHEMA")))
