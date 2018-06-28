(in-package :ter)

(defclass edge-er (shinra:ra)
  ((display :accessor display :initarg :display :initform nil)
   (hide    :accessor hide    :initarg :hide    :initform nil)))

(defmethod jojo:%to-json ((obj edge-er))
  (jojo:with-object
    (jojo:write-key-value "_id"        (slot-value obj 'up:%id))
    (jojo:write-key-value "from-id"    (slot-value obj 'shinra:from-id))
    (jojo:write-key-value "from-class" (slot-value obj 'shinra:from-class))
    (jojo:write-key-value "to-id"      (slot-value obj 'shinra:to-id))
    (jojo:write-key-value "to-class"   (slot-value obj 'shinra:to-class))
    (jojo:write-key-value "data_type"  (slot-value obj 'shinra:edge-type))
    (jojo:write-key-value "hide"       (or (slot-value obj 'hide) :false))
    (jojo:write-key-value "_class"     'edge-er)))
