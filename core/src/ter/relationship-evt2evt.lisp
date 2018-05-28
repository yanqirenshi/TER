(in-package :ter)

(defun tx-make-relationship-evt2evt-to (from to)
  ;; TODO: add assert relationships
  (let* ((correspondence nil)
         (port-from   (add-port from))
         (port-to     (add-port to))
         (port-center (add-port correspondence)))
    (make-relationships port-from '(:r :->) port-center '(:<- :r) port-to)
    (list from to port-from port-center port-to)))
