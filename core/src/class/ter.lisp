(in-package :ter)

;;;;;
;;;;; Entity
;;;;;
(defclass resource (shinra:shin rsc point rect) ())
(defclass event (shinra:shin rsc point rect) ())
(defclass correspondence (shinra:shin rsc point rect) ())
(defclass comparative (shinra:shin rsc point rect) ())
(defclass recursion (shinra:shin rsc point rect) ())


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
