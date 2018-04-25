(in-package :ter)

(defclass attribute (shinra:shin)
  ((code :accessor code :initarg :code :initform nil)
   (name :accessor name :initarg :name :initform nil)
   (data-type :accessor data-type :initarg :data-type :initform nil)))

(defclass entity (shinra:shin)
  ((code :accessor code :initarg :code :initform nil)
   (name :accessor name :initarg :name :initform nil)
   (data-type :accessor data-type :initarg :data-type :initform nil)))
