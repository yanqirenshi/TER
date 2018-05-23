(in-package :ter)

(defun find-table (graph)
  (find-vertex graph 'table))

(defun get-table (graph &key code (with-columns t))
  (let ((table (car (find-vertex graph 'table :slot 'code :value code))))
    (when table
      (when with-columns
        (setf (columns table)
              (find-table-columns *graph* table)))
      table)))

(defun tx-make-table (graph code name)
  (or (get-table graph :code code)
      (tx-make-vertex graph
                      'table
                      `((code ,code)
                        (name ,name)))))

(defun find-table-columns (graph table)
  (shinra:find-r-vertex graph 'edge-er
                        :from table
                        :vertex-class 'column
                        :edge-type :have))
