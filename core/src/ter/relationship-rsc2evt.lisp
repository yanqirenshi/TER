(in-package :ter)

(defun tx-make-relationship-rsc2evt-to (from to)
  ;; TODO: add assert relationships
  (let* ((port-from (add-port from))
         (port-to   (add-port to)))
    (make-relationships port-from '(:r :->) port-to)
    (list from to port-from port-to)))
