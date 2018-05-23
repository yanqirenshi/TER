(in-package :ter)


;;;;;
;;;;; Common
;;;;;
(defun pool-key-ra (class)
  (alexandria:make-keyword (concatenate 'string (symbol-name class) "-ROOT")))

(defun find-all-edges (graph &key (class 'shinra:ra))
  (gethash (pool-key-ra class)
           (up::root-objects graph)))

(defmethod jojo:%to-json ((obj shinra:ra))
  (jojo:with-object
    (jojo:write-key-value "_id"        (slot-value obj 'up:%id))
    (jojo:write-key-value "from-id"    (slot-value obj 'shinra:from-id))
    (jojo:write-key-value "from-class" (slot-value obj 'shinra:from-class))
    (jojo:write-key-value "to-id"      (slot-value obj 'shinra:to-id))
    (jojo:write-key-value "to-class"   (slot-value obj 'shinra:to-class))
    (jojo:write-key-value "data_type"  (slot-value obj 'shinra:edge-type))
    (jojo:write-key-value "_class"     'shinra:ra)))


;;;;;
;;;;; column ⇒ column-instance
;;;;;
(defun find-r-column_column-instance (graph &key column)
  (when column
    (shinra:find-r-vertex graph 'shinra:ra
                          :from column
                          :vertex-class 'column-instance
                          :edge-type :instance-of)))

(defun get-r-column_column-instance (graph column column-instance)
  (find-if #'(lambda (r)
               (string= (code r) (code column-instance)))
           (find-r-column_column-instance graph :column column)))

(defun tx-make-r-column_column-instance (graph column column-instance)
  (or (get-r-column_column-instance graph column column-instance)
      (tx-make-edge graph 'shinra:ra column column-instance :instance-of)))


;;;;;
;;;;; table ⇒ column-instance
;;;;;
(defun find-r-table_column-instance (graph &key table)
  (when table
    (shinra:find-r-vertex graph 'shinra:ra
                          :from table
                          :vertex-class 'column-instance
                          :edge-type :have)))

(defun get-r-table_column-instance (graph table column-instance)
  (find-if #'(lambda (r)
               (string= (code r) (code column-instance)))
           (find-r-table_column-instance graph :table table)))

(defun tx-make-r-table_column-instance (graph table column-instance)
  (or (get-r-table_column-instance graph table column-instance)
      (tx-make-edge graph 'shinra:ra table column-instance :have)))
