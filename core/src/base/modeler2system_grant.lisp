(in-package :ter)

(defun grant-authority-p (authority)
  (or (eq :reader authority)
      (eq :writer authority)
      (eq :owner  authority)))


(defun find-r-modeler2system-grant (graph modeler)
  (shinra:find-r graph 'edge-grant :from modeler
                                   :edge-type :grant-to
                                   :vertex-class 'system))


(defun get-r-modeler2system-grant (graph modeler &key system)
  (let ((r-list (find-r-modeler2system-grant graph modeler)))
    (cond (system (find-if #'(lambda (r)
                               (let ((system_tmp (getf r :vertex)))
                                 (eq (code system_tmp) (code system))))
                           r-list))
          (t (car r-list)))))


(defun get-edge-modeler2system-grant (graph modeler &key system)
  (getf (get-r-modeler2system-grant graph modeler :system system)
        :edge))


(defgeneric tx-make-edge-modeler2system-grant (graph modeler system)
  (:method (graph (modeler modeler) (system system))
    (or (get-edge-modeler2system-grant graph modeler :system system)
        (shinra:tx-make-edge graph 'edge-grant modeler system :grant-to))))


(defun owner-system-p (graph modeler system)
  (let ((edge (get-edge-modeler2system-grant graph modeler :system system)))
    (when edge
      (eq :owner (authority edge)))))


(defun tx-grant-modeler2system-update (graph edge authority)
  (unless (eq authority (authority edge))
    (shinra:tx-change-vertex graph edge :authority authority)))


(defun tx-grant-modeler2system-create (graph modeler system authority)
  (shinra:tx-make-edge graph 'edge modeler system :authority authority))


(defgeneric tx-grant-modeler2system (graph modeler system authority &key owner)
  (:method (graph (modeler modeler) (system system) (authority symbol) &key owner)
    (assert owner)
    (assert (owner-system-p graph owner system))
    (assert (grant-authority-p authority))
    (let ((edge (get-edge-modeler2system-grant graph modeler :system system)))
      (if edge
          (tx-grant-modeler2system-update graph edge           authority)
          (tx-grant-modeler2system-create graph modeler system authority)))))
