(in-package :ter)

(defclass camera (shinra:shin rsc)
  ((magnification :accessor magnification :initarg :magnification :initform 1)
   (look-at       :accessor look-at       :initarg :look-at       :initform '(:x 0 :y 0 :z 0))))

(defmethod jojo:%to-json ((obj camera))
  (jojo:with-object
    (jojo:write-key-value "_id"           (slot-value obj 'up:%id))
    (jojo:write-key-value "code"          (slot-value obj 'code))
    (jojo:write-key-value "name"          (or (slot-value obj 'name) :null))
    (jojo:write-key-value "description"   (or (slot-value obj 'description) :null))
    (jojo:write-key-value "magnification" (slot-value obj 'magnification))
    (jojo:write-key-value "look_at"       (slot-value obj 'look-at))
    (jojo:write-key-value "_class" "CAMERA")))
