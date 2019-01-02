(in-package :ter)

(defclass entity (shinra:shin rsc)
  ((location :accessor location :initarg :location :initform (make-instance 'point))
   (size     :accessor size     :initarg :size     :initform (make-instance 'rect))))
