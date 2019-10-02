(in-package :ter)


(defun get-r-force2modeler-by-modeler (graph force modeler)
  (find-if #'(lambda (r)
                 (let ((vertex (getf r :vertex)))
                   (= (up:%id force) (up:%id vertex))))
             (shinra:find-r graph 'edge-force :to modeler)))


(defun error-create-force2modeler (graph force modeler r)
  (declare (ignore graph force))
  (if (eq (up:%id modeler) (up:%id (getf r :vertex)))
      (getf r :edge)
      (error "すでにそんざいします。")))


(defun tx-create-force2modeler-core (graph force modeler)
  (shinra:tx-make-edge graph
                       'edge-force
                       force modeler
                       :have-to))


(defgeneric tx-create-force2modeler (graph force modeler)
  (:method (graph (force force) (modeler modeler))
    (let ((r (get-r-force2modeler-by-modeler graph force modeler)))
      (if (null r)
          (tx-create-force2modeler-core graph force modeler)
          (error-create-force2modeler   graph force modeler r)))))
