(in-package :ter)

(defclass identifier (shinra:shin) ())

(defclass identifier-instance (shinra:shin rsc)
  ((data-type :accessor data-type :initarg :data-type :initform nil)))
