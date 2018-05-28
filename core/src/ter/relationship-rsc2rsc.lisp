(in-package :ter)

(defun tx-make-relationship-rsc2rsc-th (graph from to)
  ;; TODO: add assert relationships
  (let* ((comparative (tx-make-comparative graph
                                           (format nil "TH_~a_~a" (code from) (code to))
                                           (format nil "~a ~a 対照表" (name from) (name to))))
         (port-from   (add-port graph from))
         (port-to     (add-port graph to))
         (port-center (add-port graph comparative)))
    (tx-make-relationships graph port-from '(:r :->) port-center '(:<- :r) port-to)))

(defun tx-make-relationship-rsc2rsc-rec (graph from to)
  ;; TODO: add assert relationships
  (let* ((port-from (add-port graph from))
         (port-to   (add-port graph to)))
    (tx-make-relationships graph port-from '(:r :->) port-to)))

(defun tx-make-relationship-rsc2rsc-dtl (graph from to)
  ;; TODO: add assert relationships
  (let* ((port-from (add-port graph from))
         (port-to   (add-port graph to)))
    (tx-make-relationships graph port-from '(:r :->) port-to)))
