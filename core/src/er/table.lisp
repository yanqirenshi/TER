(in-package :ter)

(defun find-table (graph)
  (find-vertex graph 'table))

(defun get-table (graph &key code (with-columns t))
  (let ((table (car (find-vertex graph 'table :slot 'code :value code))))
    (when table
      (when with-columns
        (setf (columns table)
              (find-table-columns graph table)))
      table)))

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

(defun find-table-columns (graph table)
  (shinra:find-r-vertex graph 'edge-er
                        :from table
                        :vertex-class 'column-instance
                        :edge-type :have))

(defun get-table-column-instance (graph table &key data code)
  (when (and graph table (or data code))
    (find-if #'(lambda (d)
                 (eq (code d)
                     (cond (data (make-column-instance-code table
                                                            (getf data :name)
                                                            (make-data-type data)))
                           (code code))))
             (find-table-columns graph table))))
