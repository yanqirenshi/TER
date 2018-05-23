(in-package :ter)

;;;;;
;;;;; column
;;;;;
(defclass column (shinra:shin)
  ((code :accessor code :initarg :code :initform nil)
   (name :accessor name :initarg :name :initform nil)
   (data-type :accessor data-type :initarg :data-type :initform nil)))

(defmethod jojo:%to-json ((obj column))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    (jojo:write-key-value "data_type" (slot-value obj 'data-type))
    (jojo:write-key-value "_class" 'column)))

;;;;;
;;;;; column-instance
;;;;;
(defclass column-instance (shinra:shin)
  ((code :accessor code :initarg :code :initform nil)
   (name :accessor name :initarg :name :initform nil)
   (data-type :accessor data-type :initarg :data-type :initform nil)))

(defmethod jojo:%to-json ((obj column-instance))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    (jojo:write-key-value "data_type" (slot-value obj 'data-type))
    (jojo:write-key-value "_class" 'column-instance)))

;;;;;
;;;;; table
;;;;;
(defclass table (shinra:shin)
  ((code       :accessor code       :initarg :code       :initform nil)
   (name       :accessor name       :initarg :name       :initform nil)
   (columns :accessor columns :initarg :columns :initform nil)))

(defmethod jojo:%to-json ((obj table))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    (when-let (slot-value obj'columns)
      (jojo:write-key-value "columns" (slot-value obj'columns)))
    (jojo:write-key-value "_class" 'table)))

;;;;;
;;;;; Relationship
;;;;;
(defclass edge-er (shinra:ra) ())

(defmethod jojo:%to-json ((obj edge-er))
  (jojo:with-object
    (jojo:write-key-value "_id"        (slot-value obj 'up:%id))
    (jojo:write-key-value "from-id"    (slot-value obj 'shinra:from-id))
    (jojo:write-key-value "from-class" (slot-value obj 'shinra:from-class))
    (jojo:write-key-value "to-id"      (slot-value obj 'shinra:to-id))
    (jojo:write-key-value "to-class"   (slot-value obj 'shinra:to-class))
    (jojo:write-key-value "data_type"  (slot-value obj 'shinra:edge-type))
    (jojo:write-key-value "_class"     'edge-er)))
