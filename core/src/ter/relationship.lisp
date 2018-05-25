(in-package :ter)

(defun find-ter-all-edges (graph &key (class 'edge-ter))
  (gethash (pool-key-ra class)
           (up::root-objects graph)))
