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

;;;;;
;;;;; column-instance ⇒ port-er
;;;;;
(defun get-column-instance-port (graph column-instance type &key (ensure t))
  (warn "この関数は廃棄予定です。column-instance-port を利用してください。")
  (let ((ports (shinra:find-r-vertex graph 'edge-er
                                     :from column-instance
                                     :vertex-class (port-type2class type)
                                     :edge-type :have)))
    (when (< 1 (length ports)) (warn "port count over 2"))
    (or (first ports)
        (when ensure
          (add-port-er graph type column-instance)))))

(defgeneric column-instance-port (graph column-instance type &key ensure)
  (:method (graph (column-instance column-instance) type &key (ensure t))
    (let ((ports (shinra:find-r-vertex graph 'edge-er
                                       :from column-instance
                                       :vertex-class (port-type2class type)
                                       :edge-type :have)))
      (when (< 1 (length ports)) (warn "port count over 2"))
      (or (first ports)
          (when ensure
            (add-port-er graph type column-instance))))))

;;;;;
;;;;; port-er ⇒ port-er
;;;;;
(defun find-r-port-er-from-to-port-er-in (graph from)
  (shinra:find-r-edge graph 'edge-er
                      :from from
                      :edge-type :fk
                      :vertex-class 'port-er-in))


(defgeneric get-r-port-er-to-port-er (graph out in)
  (:method (graph (out port-er-out) (in port-er-in))
    (find-if #'(lambda (d)
                 (= (up:%id d) (up:%id in)))
             (shinra:find-r-vertex graph 'edge-er
                                   :from out
                                   :edge-type :fk
                                   :vertex-class 'port-er-in))))

(defgeneric tx-make-r-port-er (graph out in)
  (:method (graph (out port-er-out) (in port-er-in))
    (or (get-r-port-er-to-port-er graph out in)
        (tx-make-edge graph 'edge-er out in :fk))))

;;;;;
;;;;; table ⇒ column-instance port
;;;;;
(defgeneric get-table-column-instances-port (graph type table column-code)
  (:method ((schema schema) type (table table) (column-code symbol))
    (get-table-column-instances-port (get-schema-graph schema) type table column-code))

  (:method ((graph shinra:banshou) type (table table) (column-code symbol))
    (warn "このオペレータは廃棄予定です。\ntable-column-instances-portを利用してください。")
    (let ((column-instance (get-column-instance graph :code column-code)))
      (if (null column-instance)
          (warn "Not found column instance. column-code=~a" column-code)
          (or (first (shinra:find-r-vertex graph 'edge-er
                                           :from column-instance
                                           :vertex-class (ter::port-type2class type)
                                           :edge-type :have))
              (add-port-er graph type column-instance))))))

;; new
(defgeneric table-column-instances-port (graph type table column)
  (:method ((graph shinra:banshou) type (table-code symbol) (column-code symbol))
    (let ((column-instance (table-column-instance graph table-code column-code)))
      (if (null column-instance)
          (warn "Not found column instance. column-code=~a" column-code)
          (column-instance-port graph column-instance type :ensure t)))))
