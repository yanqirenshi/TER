(in-package :ter)

(defclass system (shinra:shin rsc) ())

(defmethod jojo:%to-json ((obj system))
  (jojo:with-object
    (jojo:write-key-value "_id"           (slot-value obj 'up:%id))
    (jojo:write-key-value "code"          (slot-value obj 'code))
    (jojo:write-key-value "name"          (or (slot-value obj 'name) :null))
    (jojo:write-key-value "description"   (or (slot-value obj 'description) :null))
    (jojo:write-key-value "_class"        "SYSTEM")))
