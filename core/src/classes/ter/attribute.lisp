(in-package :ter)

(defclass attribute (shinra:shin) ())

(defclass attribute-instance (shinra:shin rsc)
 ((data-type :accessor data-type :initarg :data-type :initform nil)))
