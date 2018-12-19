(in-package :ter)

(defun find-edge-ghost-shadow2modeler (graph &key ghost-shadow modeler)
  (cond ((and ghost-shadow modeler)
         (remove-if #'(lambda (r)
                        (eq (getf r :vertex) modeler))
                    (find-edge-ghost-shadow2modeler graph :ghost-shadow ghost-shadow)))
        (ghost-shadow
         (shinra:find-r graph 'edge
                        :from ghost-shadow
                        :vertex-class 'modeler
                        :edge-type :have-to))
        (modeler
         (shinra:find-r graph 'edge
                        :to modeler
                        :vertex-class 'ghost-shadow
                        :edge-type :have-to))))

(defun get-edge-ghost-shadow2modeler (graph ghost-shadow modeler)
  (let ((edge (find-edge-ghost-shadow2modeler graph :ghost-shadow ghost-shadow :modeler modeler)))
    (when edge
      (getf (car edge) :edge))))

(defun tx-make-edge-ghost-shadow2modeler (graph ghost-shadow modeler)
  (when (get-edge-ghost-shadow2modeler graph ghost-shadow modeler)
    (error "Aledy exist edge of ghost-shadow to modeler. ghost-shadow=~S modeler=~S"
           ghost-shadow modeler))
  (shinra:tx-make-edge graph 'edge ghost-shadow modeler :have-to))
