(in-package :ter)

(defun tx-make-relationship-rsc2evt-to (graph from to)
  ;; TODO: add assert relationships
  (let* ((port-from (add-port graph from))
         (port-to   (add-port graph to)))
    (tx-make-relationships graph port-from '(:r :->) port-to)))
