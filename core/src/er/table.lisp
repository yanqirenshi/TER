(in-package :ter)

(defun find-table (graph)
  (find-vertex graph 'table))

(defgeneric get-table (graph &key code with-columns)
  (:method ((schema schema) &key code (with-columns t))
    (get-table (get-schema-graph schema) :code code :with-columns with-columns))
  (:method ((graph shinra:banshou) &key code (with-columns t))
    (let ((table (car (find-vertex graph 'table :slot 'code :value code))))
      (when table
        (when with-columns
          (setf (columns table)
                (find-table-column-instances graph table)))
        table))))

(defun tx-make-table (graph code name)
  (or (get-table graph :code code)
      (tx-make-vertex graph
                      'table
                      `((code ,code)
                        (name ,name)
                        (x ,(random (* 1920 2)))
                        (y ,(random (* 1080 2)))
                        (w 222)
                        (h 333)))))

(defgeneric find-table-column-instances (graph table)
  (:method ((schema schema) (table table))
    (find-table-column-instances (get-schema-graph schema) table))
  (:method ((graph shinra:banshou) (table table))
    (shinra:find-r-vertex graph 'edge-er
                          :from table
                          :vertex-class 'column-instance
                          :edge-type :have)))
