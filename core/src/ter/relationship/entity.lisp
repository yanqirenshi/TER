(in-package :ter)


(defun get-entity-column-at-code (graph entity column-class code)
  (find-if #'(lambda (r)
               (let ((vertex (getf r :vertex)))
                 (string= code (code vertex))))
           (shinra:find-r graph 'edge-ter
                          :from entity
                          :vertex-class column-class
                          :edge-type :have-to)))
