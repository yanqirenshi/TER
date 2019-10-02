(in-package :ter)

(defvar *force-codes* (list :grand-master))


(defclass force (shinra:shin rsc) ())


(defmethod jojo:%to-json ((obj force))
  (jojo:with-object
    (jojo:write-key-value "_id"           (slot-value obj 'up:%id))
    (jojo:write-key-value "code"          (slot-value obj 'code))
    (jojo:write-key-value "name"          (or (slot-value obj 'name) :null))
    (jojo:write-key-value "description"   (or (slot-value obj 'description) :null))
    (jojo:write-key-value "_class" "FORCE")))
