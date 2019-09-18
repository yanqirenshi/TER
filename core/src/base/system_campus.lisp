(in-package :ter)

(defun get-r-system2campus (graph system campus)
  (find-if #'(lambda (r)
               (let ((campus_tmp (getf r :vertex)))
                 (eq (code campus_tmp) (code campus))))
           (shinra:find-r graph 'edge :from system
                                      :edge-type :have-to
                                      :vertex-class 'campus)))


(defun get-edge-system2campus (graph system campus)
  (when-let ((r (get-r-system2campus graph system campus)))
    (getf r :edge)))


(defgeneric tx-make-edge-system2campus (graph system campus)
  (:method (graph (system system) (campus campus))
    (or (get-edge-system2campus graph system campus)
        (shinra:tx-make-edge graph 'edge system campus :have-to))))
