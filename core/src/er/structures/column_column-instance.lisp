(in-package :ter)


(defun find-r-column_column-instance (graph &key column)
  (when column
    (shinra:find-r-vertex graph 'edge-ter
                          :from column
                          :vertex-class 'column-instance
                          :edge-type :instance-of)))


(defun column_column-instance (graph column column-instance)
  (find-if #'(lambda (r)
               (string= (code r) (code column-instance)))
           (find-r-column_column-instance graph :column column)))


(defun tx-make-r-column_column-instance (graph column column-instance)
  (or (column_column-instance graph column column-instance)
      (tx-make-edge graph 'edge-er column column-instance :instance-of)))
