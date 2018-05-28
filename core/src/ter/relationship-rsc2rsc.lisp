(in-package :ter)

(defun tx-make-relationship-rsc2rsc-th (from to)
  ;; TODO: add assert relationships
  (let* ((comparative nil)
         (port-from   (add-port from))
         (port-to     (add-port to))
         (port-center (add-port comparative)))
    (make-relationships port-from '(:r :->) port-center '(:<- :r) port-to)
    (list from to port-from port-center port-to)))

(defun tx-make-relationship-rsc2rsc-rec (from to)
  ;; TODO: add assert relationships
  (let* ((port-from (add-port from))
         (port-to   (add-port to)))
    (make-relationships port-from '(:r :<->) port-to)
    (list from to port-from port-to)))

(defun tx-make-relationship-rsc2rsc-dtl (from to)
  ;; TODO: add assert relationships
  (let* ((port-from (add-port from))
         (port-to   (add-port to)))
    (make-relationships port-from '(:r :->) port-to)
    (list from to port-from port-to)))
