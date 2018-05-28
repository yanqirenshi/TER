(in-package :ter)

(defun tx-make-relationship-evt2evt-to (graph from to)
  ;; TODO: add assert relationships
  (let* ((correspondence nil)
         (port-from   (add-port graph from))
         (port-to     (add-port graph to))
         (port-center (add-port graph correspondence)))
    (tx-make-relationships graph port-from '(:r :->) port-center '(:<- :r) port-to)))
