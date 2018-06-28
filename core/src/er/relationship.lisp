(in-package :ter)


;;;;;
;;;;; Common
;;;;;
(defun pool-key-ra (class)
  (alexandria:make-keyword (concatenate 'string (symbol-name class) "-ROOT")))

(defun find-er-all-edges (graph &key (class 'edge-er))
  (gethash (pool-key-ra class)
           (up::root-objects graph)))

;;;;;
;;;;; column ⇒ column-instance
;;;;;
(defun find-r-column_column-instance (graph &key column)
  (when column
    (shinra:find-r-vertex graph 'edge-ter
                          :from column
                          :vertex-class 'column-instance
                          :edge-type :instance-of)))

(defun get-r-column_column-instance (graph column column-instance)
  (find-if #'(lambda (r)
               (string= (code r) (code column-instance)))
           (find-r-column_column-instance graph :column column)))

(defun tx-make-r-column_column-instance (graph column column-instance)
  (or (get-r-column_column-instance graph column column-instance)
      (tx-make-edge graph 'edge-er column column-instance :instance-of)))


;;;;;
;;;;; table ⇒ column-instance
;;;;;
(defun find-r-table_column-instance (graph &key table)
  (when table
    (shinra:find-r-vertex graph 'edge-ter
                          :from table
                          :vertex-class 'column-instance
                          :edge-type :have)))

(defun get-r-table_column-instance (graph table column-instance)
  (find-if #'(lambda (r)
               (string= (code r) (code column-instance)))
           (find-r-table_column-instance graph :table table)))

(defun tx-make-r-table_column-instance (graph table column-instance)
  (or (get-r-table_column-instance graph table column-instance)
      (tx-make-edge graph 'edge-er table column-instance :have)))

;;;;;
;;;;; port-er ⇒ port-er
;;;;;
(defun find-r-port-er-from-to-port-er-in (graph from)
  (shinra:find-r-edge graph 'edge-er
                      :from from
                      :edge-type :fk
                      :vertex-class 'port-er-in))


(defgeneric get-r-port-er-to-port-er (graph from to)
  (:method (graph (from port-er-out) (to port-er-in))
    (find-if #'(lambda (d)
                 (= (up:%id d) (up:%id to)))
             (shinra:find-r-vertex graph 'edge-er
                                   :from from
                                   :edge-type :fk
                                   :vertex-class 'port-er-in))))

(defgeneric tx-make-r-port-er-to-port-er (graph from to)
  (:method (graph (from port-er) (to port-er))
    (or (get-r-port-er-to-port-er graph from to)
        (tx-make-edge graph 'edge-er from to :fk))))
