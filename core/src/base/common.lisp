(in-package :ter)

(defclass edge (shinra:ra) ())


(defclass edge-grant (shinra:ra)
  ((authority :documentation ""
              :accessor authority
              :initarg :authority
              :initform nil)))
