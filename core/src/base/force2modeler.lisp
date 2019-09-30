(in-package :ter)


(defun get-r-force2modeler-by-modeler (graph modeler)
  (find-if #'(lambda (r)
                 (let ((edge (getf r :edge)))
                   (eq :owner (authority edge))))
             (shinra:find-r graph 'edge-force :to modeler)))


(defun error-create-force2modeler (graph force modeler r)
  (declare (ignore graph force))
  (if (eq (up:%id modeler) (up:%id (getf r :vertex)))
      (getf r :edge)
      (error "すでにそんざいします。")))


(defun tx-create-force2modeler-core (graph force modeler &key force-class)
  (assert force-class)
  (assert (find force-class *force-classes*))
  (shinra:tx-make-edge graph
                       'edge-force
                       force modeler
                       :have-to
                       `((force-class ,force-class))))


(defgeneric tx-create-force2modeler (graph force modeler &key force-class)
  (:method (graph (force force) (modeler modeler) &key force-class)
    (let ((r (get-r-force2modeler-by-modeler graph modeler)))
      (if (null r)
          (tx-create-force2modeler-core graph force modeler :force-class force-class)
          (error-create-force2modeler   graph force modeler r)))))
