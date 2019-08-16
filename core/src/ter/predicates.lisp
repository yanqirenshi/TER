(in-package :ter)

(defgeneric entity-p (obj)
  (:method ((obj resource)) t)
  (:method ((obj event)) t)
  (:method ((obj correspondence)) t)
  (:method ((obj comparative)) t)
  (:method ((obj recursion)) t)
  (:method (obj) nil))

(defgeneric port-ter-p (obj)
  (:method ((obj port-ter)) t)
  (:method (obj) nil))
