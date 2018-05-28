(in-package :ter)

(defclass port (shinra:shin rsc point) ())

(defmethod jojo:%to-json ((obj port))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    ;; point
    (jojo:write-key-value "x" (slot-value obj 'x))
    (jojo:write-key-value "y" (slot-value obj 'y))
    (jojo:write-key-value "z" (slot-value obj 'z))
    (jojo:write-key-value "_class" "port")))


;;;;;
;;;;; Entity
;;;;;
(defclass resource (shinra:shin rsc point rect) ())

(defmethod jojo:%to-json ((obj resource))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    ;; point
    (jojo:write-key-value "x" (slot-value obj 'x))
    (jojo:write-key-value "y" (slot-value obj 'y))
    (jojo:write-key-value "z" (slot-value obj 'z))
    ;; rect
    (jojo:write-key-value "w" (slot-value obj 'w))
    (jojo:write-key-value "h" (slot-value obj 'h))
    (jojo:write-key-value "_class" "RESOURCE")))

(defclass event (shinra:shin rsc point rect) ())

(defmethod jojo:%to-json ((obj event))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    ;; point
    (jojo:write-key-value "x" (slot-value obj 'x))
    (jojo:write-key-value "y" (slot-value obj 'y))
    (jojo:write-key-value "z" (slot-value obj 'z))
    ;; rect
    (jojo:write-key-value "w" (slot-value obj 'w))
    (jojo:write-key-value "h" (slot-value obj 'h))
    (jojo:write-key-value "_class" "EVENT")))

(defclass correspondence (shinra:shin rsc point rect) ()
  (:documentation "対応表"))

(defmethod jojo:%to-json ((obj correspondence))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    ;; point
    (jojo:write-key-value "x" (slot-value obj 'x))
    (jojo:write-key-value "y" (slot-value obj 'y))
    (jojo:write-key-value "z" (slot-value obj 'z))
    ;; rect
    (jojo:write-key-value "w" (slot-value obj 'w))
    (jojo:write-key-value "h" (slot-value obj 'h))
    (jojo:write-key-value "_class" "CORRESPONDENCE")))

(defclass comparative (shinra:shin rsc point rect) ()
  (:documentation "対照表"))

(defmethod jojo:%to-json ((obj comparative))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    ;; point
    (jojo:write-key-value "x" (slot-value obj 'x))
    (jojo:write-key-value "y" (slot-value obj 'y))
    (jojo:write-key-value "z" (slot-value obj 'z))
    ;; rect
    (jojo:write-key-value "w" (slot-value obj 'w))
    (jojo:write-key-value "h" (slot-value obj 'h))
    (jojo:write-key-value "_class" "COMPARATIVE")))

(defclass recursion (shinra:shin rsc point rect) ())

(defmethod jojo:%to-json ((obj recursion))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj 'up:%id))
    (jojo:write-key-value "code" (slot-value obj 'code))
    (jojo:write-key-value "name" (slot-value obj 'name))
    ;; point
    (jojo:write-key-value "x" (slot-value obj 'x))
    (jojo:write-key-value "y" (slot-value obj 'y))
    (jojo:write-key-value "z" (slot-value obj 'z))
    ;; rect
    (jojo:write-key-value "w" (slot-value obj 'w))
    (jojo:write-key-value "h" (slot-value obj 'h))
    (jojo:write-key-value "_class" "RECURSION")))


;;;;;
;;;;; Identifier
;;;;;
;; identifier
;; identifier-instance
(defclass identifier (shinra:shin) ())
(defclass identifier-instance (shinra:shin) ())


;;;;;
;;;;; Attribute
;;;;;
(defclass attribute (shinra:shin) ())
(defclass attribute-instance (shinra:shin) ())


;;;;;
;;;;; Relationship
;;;;;
(defclass edge-ter (shinra:ra) ())
