(in-package :ter)


(defun pool-key-ra (class)
  (alexandria:make-keyword (concatenate 'string (symbol-name class) "-ROOT")))


(defun find-er-all-edges (graph &key (class 'edge-er))
  (gethash (pool-key-ra class)
           (up::root-objects graph)))
