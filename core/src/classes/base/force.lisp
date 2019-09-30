(in-package :ter)

(defvar *force-classes* (list :grand-master))


(defclass force (shinra:shin rsc)
  ((force-class :accessor force-class :initarg :force-class :initform nil)))


(defmethod jojo:%to-json ((obj force))
  (jojo:with-object
    (jojo:write-key-value "_id"           (slot-value obj 'up:%id))
    (jojo:write-key-value "code"          (slot-value obj 'code))
    (jojo:write-key-value "name"          (or (slot-value obj 'name) :null))
    (jojo:write-key-value "description"   (or (slot-value obj 'description) :null))
    (jojo:write-key-value "force-class"   (slot-value obj 'force-class))
    (jojo:write-key-value "_class" "FORCE")))
