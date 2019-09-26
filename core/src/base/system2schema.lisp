(in-package :ter)

(defun get-r-system2schema (graph system schema)
  (find-if #'(lambda (r)
               (let ((schema_tmp (getf r :vertex)))
                 (eq (code schema_tmp) (code schema))))
           (shinra:find-r graph 'edge :from system
                                      :edge-type :have-to
                                      :vertex-class 'schema)))


(defun get-edge-system2schema (graph system schema)
  (when-let ((r (get-r-system2schema graph system schema)))
    (getf r :edge)))


(defgeneric tx-make-edge-system2schema (graph system schema)
  (:method (graph (system system) (schema schema))
    (or (get-edge-system2schema graph system schema)
        (shinra:tx-make-edge graph 'edge system schema :have-to))))
