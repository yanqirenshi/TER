(in-package :ter)

(defun grant-authority-p (authority)
  (or (eq :reader authority)
      (eq :writer authority)
      (eq :owner  authority)))


(defun find-r-modeler2system-grant-all (graph modeler)
  (shinra:find-r graph 'edge-grant :from modeler
                                   :edge-type :grant-to
                                   :vertex-class 'system))


(defun find-r-modeler2system-grant (graph modeler &key authority)
  (let ((all (find-r-modeler2system-grant-all graph modeler)))
    (if (null authority)
        all
        (flet ((is-owner (r) ;; TODO: これはキチンと抽象化したい。
                 (let ((edge (getf r :edge)))
                   (not (eq authority (authority edge))))))
          (remove-if #'is-owner all)))))


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
  (shinra:tx-make-edge graph 'edge-grant modeler system :grant-to `((authority ,authority))))


(defun get-r-system-owner (graph system)
  (find-if #'(lambda (r)
                 (let ((edge (getf r :edge)))
                   (eq :owner (authority edge))))
             (shinra:find-r graph 'edge-grant :to system)))


(defun tx-grant-modeler2system-core (graph modeler system authority)
  (let ((r (get-r-system-owner graph system)))
    (if (null r)
        (tx-grant-modeler2system-create graph modeler system authority)
        (if (eq (up:%id modeler) (up:%id (getf r :vertex)))
            (getf r :edge)
            (error "すでにそんざいします。")))))


(defgeneric tx-grant-modeler2system (graph modeler system authority &key owner)
  (:method (graph (modeler modeler) (system system) (authority symbol) &key owner)
    (assert owner)
    (assert (owner-system-p graph owner system))
    (assert (grant-authority-p authority))
    (tx-grant-modeler2system-core graph modeler system authority)))


(defgeneric can-use-system-p (graph target modeler authorities)
  (:method (graph (schema schema) modeler authorities)
    (when-let ((system (get-system graph :schema schema)))
      (can-use-system-p graph system modeler authorities)))

  (:method (graph (campus campus) modeler authorities)
    (when-let ((system (get-system graph :campus campus)))
      (can-use-system-p graph system modeler authorities)))

  (:method (graph (system system) modeler authorities)
    (let ((edge (get-edge-modeler2system-grant graph modeler :system system)))
      (when edge
        (if (find (authority edge) authorities) t nil)))))
