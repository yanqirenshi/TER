(in-package :ter)

(defun find-r-modeler2system-select (graph modeler)
  (shinra:find-r graph 'edge :from modeler
                             :edge-type :select-at
                             :vertex-class 'system))

(defun get-r-modeler2system-select (graph modeler &key system)
  (let ((r-list (find-r-modeler2system-select graph modeler)))
    (cond (system (find-if #'(lambda (r)
                               (let ((system_tmp (getf r :vertex)))
                                 (eq (code system_tmp) (code system))))
                           r-list))
          (t (car r-list)))))

(defun get-edge-modeler2system (graph modeler &key system)
  (getf (get-r-modeler2system-select graph modeler :system system)
        :edge))

(defgeneric tx-make-edge-modeler2system-select (graph modeler system)
  (:method (graph (modeler modeler) (system system))
    (or (get-edge-modeler2system graph modeler :system system)
        (shinra:tx-make-edge graph 'edge modeler system :select-at))))

(defgeneric tx-change-system-at-modeler2system (graph edge system)
  (:method (graph (edge edge) (system system))
    (shinra:tx-change-vertex graph edge :to system)))

(defgeneric tx-change-select-system (graph modeler system)
  (:method (graph modeler system)
    (unless (get-r-modeler2system-select graph modeler :system system)
      (let ((edge (get-edge-modeler2system graph modeler)))
        (if edge
            (tx-change-system-at-modeler2system graph edge system)
            (tx-make-edge-modeler2system-select graph modeler system))))))
