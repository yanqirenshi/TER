(in-package :ter)

;;;;;
;;;;; attribute
;;;;;
(defclass attribute (shinra:shin)
  ((code :accessor code :initarg :code :initform nil)
   (name :accessor name :initarg :name :initform nil)
   (data-type :accessor data-type :initarg :data-type :initform nil)))

(defmethod jojo:%to-json ((obj attribute))
  (jojo:with-object
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    (jojo:write-key-value "data_type" (slot-value obj 'data-type))
    (jojo:write-key-value "_class" 'attribute)))

;;;;;
;;;;; entity
;;;;;
(defclass entity (shinra:shin)
  ((code       :accessor code       :initarg :code       :initform nil)
   (name       :accessor name       :initarg :name       :initform nil)
   (attributes :accessor attributes :initarg :attributes :initform nil)))

(defmethod jojo:%to-json ((obj entity))
  (jojo:with-object
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    (when-let (slot-value obj'attributes)
      (jojo:write-key-value "attributes" (slot-value obj'attributes)))
    (jojo:write-key-value "_class" 'entity)))

;;;;;
;;;;; attribute-entity
;;;;;
(defclass attribute-entity (shinra:shin)
  ((code :accessor code :initarg :code :initform nil)
   (name :accessor name :initarg :name :initform nil)
   (data-type :accessor data-type :initarg :data-type :initform nil)))

(defmethod jojo:%to-json ((obj attribute-entity))
  (jojo:with-object
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    (jojo:write-key-value "data_type" (slot-value obj 'data-type))
    (jojo:write-key-value "_class" 'attribute-entity)))
