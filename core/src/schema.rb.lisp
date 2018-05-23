(in-package :ter)

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
;;;;; Utility
;;;;;
(defun make-code (&rest strs)
  (alexandria:make-keyword (string-upcase (apply #'concatenate 'string strs))))

(defun make-table-code (name)
  (make-code name))

(defun make-column-code (name data-type)
  (make-code name "@" data-type))

(defun make-column-instance-code (table name data-type)
  (make-code (symbol-name (code table)) "." name "@" data-type))

(defun make-data-type (data)
  (let ((limit (getf data :limit)))
    (concatenate 'string
                 (getf data :data-type)
                 (if (not limit) "" (format nil "[~a]" limit)))))


;;;;;
;;;;; Import
;;;;;
(defun tx-import-column (graph data)
  (let* ((name (getf data :name))
         (data-type (make-data-type data))
         (code (make-column-code name data-type)))
    (tx-make-column graph code name data-type)))

(defun tx-import-column-instance (graph table data)
  (let* ((name (getf data :name))
         (data-type (make-data-type data))
         (code (make-column-instance-code table name data-type)))
    (tx-make-column-instance graph code name data-type)))

(defun tx-import-columns (graph table columns-data)
  (when-let ((data (car columns-data)))
    (let* ((column (tx-import-column graph data))
           (column-instance (tx-import-column-instance graph table data)))
      (tx-make-r-column_column-instance graph column column-instance)
      (tx-make-r-table_column-instance graph table column-instance)
      (cons column-instance
            (tx-import-columns graph table (cdr columns-data))))))

(defun tx-import-make-table (graph plist)
  (let* ((data (get-table-plist plist))
         (name (getf data :name)))
    (tx-make-table graph
                    (make-table-code name)
                    name)))

(defun xxx (graph from-column-instance to-column-instance)
  (print (list from-column-instance to-column-instance)))

(defun tx-import-foreign-key (graph from-table fk)
  (let ((from-attr-table-code (make-column-instance-code from-table (getf fk :name) (make-data-type fk)))
        (to-table (get-table graph :code (make-table-code (getf (getf fk :foreign-key) :references)))))
    (xxx graph
         (get-column-instance graph :code from-attr-table-code)
         (get-id-column-instance graph to-table))))

(defun tx-import-foreign-keys (graph table plist)
  (dolist (fka (find-foreign-key-plists plist))
    (tx-import-foreign-key graph table fka)))

(defun get-id-column-instance (graph table)
  (find-if #'(lambda (attr)
               (eq (code attr)
                   (make-column-instance-code table "id" "integer")))
           (shinra:find-r-vertex graph 'edge-er
                                 :from table)))

(defun tx-import-table (graph plist)
  (let ((table (tx-import-make-table graph plist))
        (columns-data (cons '(:type :column :alias "t" :name "id" :data-type "integer")
                               (find-column-plists plist))))
    (tx-import-columns graph table columns-data)
    (tx-import-foreign-keys graph table plist)
    table))

;;;;;
;;;;; Main
;;;;;
(defun %import-schema.rb (graph plists)
  (when-let ((plist (car plists)))
    (cons (up:execute-transaction (tx-import-table graph plist))
          (%import-schema.rb graph (cdr plists)))))

(defun import-schema.rb (graph pathname)
  (%import-schema.rb graph (ter.parser:parse-schema.rb pathname)))
