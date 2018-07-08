(in-package :ter)

(defclass config (shinra:shin)
  ((contents :accessor contents
             :initarg :contents
             :initform '(:schema nil))))

(defmethod jojo:%to-json ((obj config))
  (jojo:with-object
    (jojo:write-key-value "_id"      (slot-value obj 'up:%id))
    (jojo:write-key-value "contents" (slot-value obj 'contents))
    (jojo:write-key-value "_class" "CONFIG")))
