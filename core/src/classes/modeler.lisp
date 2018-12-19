(in-package :ter)

(defclass ghost-shadow (shinra:shin)
  ((ghost-id :accessor ghost-id :initarg :ghost-id :initform nil)))

(defclass modeler (shinra:shin)
  ((name :accessor name :initarg :name :initform nil)))
