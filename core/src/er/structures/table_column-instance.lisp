(in-package :ter)


(defun find-r-table_column-instance (graph &key table)
  (when table
    (shinra:find-r-vertex graph 'edge-ter
                          :from table
                          :vertex-class 'column-instance
                          :edge-type :have)))


(defun table_column-instance (graph table column-instance)
  (find-if #'(lambda (r)
               (string= (code r) (code column-instance)))
           (find-r-table_column-instance graph :table table)))


(defun tx-make-r-table_column-instance (graph table column-instance)
  (or (table_column-instance graph table column-instance)
      (tx-make-edge graph 'edge-er table column-instance :have)))


(defun get-table-column-instance (graph table &key data code)
  (when (and graph table (or data code))
    (find-if #'(lambda (d)
                 (eq (code d)
                     (cond (data (make-column-instance-code table
                                                            (getf data :name)))
                           (code code))))
             (find-table-column-instances graph table))))


(defgeneric table-column-instance-p (table column-instance)
  (:method ((table-code symbol) (column-instance-code symbol))
    (let ((list (split-sequence:split-sequence #\. (symbol-name column-instance-code))))
      (and (= 2 (length list))
           (string= (symbol-name table-code)
                    (first list))))))


(defgeneric table-column-instance (graph table column-instance)
  ;;
  (:method (graph (table-code symbol) (column-instance-code symbol))
    (let ((table (get-table graph :code table-code)))
      (table-column-instance graph
                             table
                             (if (table-column-instance-p table-code column-instance-code)
                                 column-instance-code
                                 (make-column-instance-code table-code column-instance-code)))))
  ;;
  (:method (graph (table table) (column-instance-code symbol))
    (get-table-column-instance graph table :code column-instance-code)))
