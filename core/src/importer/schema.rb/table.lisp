(in-package :ter)

(defgeneric table-p (o)
  (:method ((table table)) (declare (ignore table)) t)
  (:method (o) (declare (ignore o)) nil))

;;;;;
;;;;; get / find
;;;;;
(defun get-table-plist (plists)
  (when-let ((plist (car plists)))
    (if (eq :table-start (getf plist :type))
        plist
        (get-table-plist (cdr plists)))))

(defun find-column-plists (plists)
  (when-let ((plist (car plists)))
    (if (not (eq :column (getf plist :type)))
        (find-column-plists (cdr plists))
        (cons plist
              (find-column-plists (cdr plists))))))

(defun find-foreign-key-plists (plists)
  (when-let ((plist (car plists)))
    (if (not (getf plist :foreign-key))
        (find-foreign-key-plists (cdr plists))
        (cons plist
              (find-foreign-key-plists (cdr plists))))))

;;;;;
;;;;; Import
;;;;;
(defun tx-import-column (graph data)
  (let* ((name (getf data :name))
         (data-type (make-data-type data))
         (code (make-column-code name data-type)))
    ;; TODO: Need update, if exists
    (tx-make-column graph code name data-type)))

(defun tx-import-column-instance (graph table data)
  (let* ((name (getf data :name))
         (data-type (make-data-type data))
         (code (make-column-instance-code table name))
         (column-instance (get-table-column-instance graph table :data data)))
    (if column-instance
        (tx-update-column-instance graph column-instance
                                   name
                                   data-type
                                   (make-column-column-type name))
        (tx-make-column-instance graph code name
                                 data-type
                                 (make-column-column-type name)))))

(defun %tx-import-columns (graph table column-data)
  (let* ((column (tx-import-column graph column-data))
         (column-instance (tx-import-column-instance graph table column-data)))
    (tx-make-r-column_column-instance graph column column-instance)
    (tx-make-r-table_column-instance graph table column-instance)
    column-instance))

(defun tx-import-columns (graph table columns-data)
  (when-let ((column-data (car columns-data)))
    (cons (%tx-import-columns graph table column-data)
          (tx-import-columns graph table (cdr columns-data)))))

(defun tx-import-make-table (graph plist)
  (let* ((data (get-table-plist plist))
         (name (getf data :name)))
    (tx-make-table graph
                   (make-table-code name)
                   name)))

(defun get-id-column-instance (graph table)
  (find-if #'(lambda (attr)
               (eq (code attr)
                   (make-column-instance-code table "id")))
           (shinra:find-r-vertex graph 'edge-er
                                 :from table)))

(defun tx-import-tables (graph plist)
  (let ((table (tx-import-make-table graph plist))
        (columns-data (cons '(:type :column :alias "t" :name "id" :data-type "integer")
                            (find-column-plists plist))))
    (tx-import-columns graph table columns-data)
    table))

;;;;;
;;;;; fk
;;;;;
(defun %table2import-fk-datas (table table-plist)
  (when-let ((plist (car table-plist)))
    (let ((foreign-key (getf plist :foreign-key)))
      (if (null foreign-key)
          (%table2import-fk-datas table (cdr table-plist))
          (let ((from-table (getf foreign-key :references)))
            (cons (make-import-fk-data from-table :id table (list :to-column (getf plist :name)))
                  (%table2import-fk-datas table (cdr table-plist))))))))

(defun table2import-fk-datas (table-plist)
  (let ((table-name (getf (get-table-plist table-plist) :name)))
    (%table2import-fk-datas table-name table-plist)))

(defun tables2import-fk-datas (tables-plists)
  (reduce #'(lambda (a b)
              (nconc a (table2import-fk-datas b)))
          tables-plists
          :initial-value '()))
