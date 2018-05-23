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
(defclass ter-identifier (shinra:shin) ())
(defclass ter-identifier-instance (shinra:shin) ())


;;;;;
;;;;; Attribute
;;;;;
(defclass ter-attribute (shinra:shin) ())
(defclass ter-attribute-instance (shinra:shin) ())


;;;;;
;;;;; Relationship
;;;;;
(defclass ter-edge (shinra:ra) ())
