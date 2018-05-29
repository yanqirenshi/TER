(in-package :ter)

(defclass port-er (shinra:shin rsc point) ())

(defmethod jojo:%to-json ((obj port-er))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    ;; point
    (jojo:write-key-value "x" (slot-value obj 'x))
    (jojo:write-key-value "y" (slot-value obj 'y))
    (jojo:write-key-value "z" (slot-value obj 'z))
    (jojo:write-key-value "_class" "port")))

;;;;;
;;;;; column
;;;;;
(defclass column (shinra:shin rsc)
  ((data-type :accessor data-type :initarg :data-type :initform nil)))

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

;;;;;
;;;;; table
;;;;;
(defclass table (shinra:shin rsc point rect)
  ((columns :accessor columns :initarg :columns :initform nil)))

(defmethod jojo:%to-json ((obj table))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    (when-let (slot-value obj'columns)
      (jojo:write-key-value "columns" (slot-value obj'columns)))
    (jojo:write-key-value "_class" 'table)
    ;; point
    (jojo:write-key-value "x" (slot-value obj 'x))
    (jojo:write-key-value "y" (slot-value obj 'y))
    (jojo:write-key-value "z" (slot-value obj 'z))
    ;; rect
    (jojo:write-key-value "w" (slot-value obj 'w))
    (jojo:write-key-value "h" (slot-value obj 'h))))

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
