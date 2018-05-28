(in-package :ter)

(defgeneric add-port (from )
  (:method ((from resource))
    (list from))
  (:method ((from event))
    (list from)))

(defun find-ter-all-edges (graph &key (class 'edge-ter))
  (gethash (pool-key-ra class)
           (up::root-objects graph)))

(defun make-relationships (&rest statements)
  statements)
