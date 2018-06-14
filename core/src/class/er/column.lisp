(in-package :ter)

(defclass column (shinra:shin rsc)
  ((data-type :accessor data-type :initarg :data-type :initform nil)))

(defmethod jojo:%to-json ((obj column))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    (jojo:write-key-value "data_type" (slot-value obj 'data-type))
    (jojo:write-key-value "_class" 'column)))

(defclass column-instance (shinra:shin rsc)
  ((data-type   :accessor data-type   :initarg :data-type   :initform nil)
   (column-type :accessor column-type :initarg :column-type :initform nil)))

(defmethod jojo:%to-json ((obj column-instance))
  (jojo:with-object
    (jojo:write-key-value "_id"         (slot-value obj 'up:%id))
    (jojo:write-key-value "code"        (slot-value obj 'code))
    (jojo:write-key-value "name"        (slot-value obj 'name))
    (jojo:write-key-value "data_type"   (slot-value obj 'data-type))
    (jojo:write-key-value "column_type" (slot-value obj 'column-type))
    (jojo:write-key-value "_class" 'column-instance)))
