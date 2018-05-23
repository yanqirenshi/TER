(in-package :ter)

;;;;;
;;;;; Entity
;;;;;
(defclass resource (shinra:shin) ())
(defclass event (shinra:shin) ())
(defclass correspondence (shinra:shin) ())
(defclass comparative (shinra:shin) ())
(defclass recursion (shinra:shin) ())


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
