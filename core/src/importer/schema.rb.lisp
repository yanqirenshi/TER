(in-package :ter)

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

(defun make-column-column-type (name)
  (let ((attribute-names '("created_at" "creator_id" "updated_at" "updater_id")))
    (cond ((or (find name attribute-names :test 'string=)) :timestamp)
          ((string= "id" name) :id)
          ((cl-ppcre:scan "^.*_id$" name) :id)
          (t :attribute))))

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
    (tx-make-column-instance graph code name
                             data-type
                             (make-column-column-type name))))

(defun tx-import-columns (graph table columns-data)
  (when-let ((data (car columns-data)))
    (cons (or (get-table-column-instance graph table :data data)
              (let* ((column (tx-import-column graph data))
                     (column-instance (tx-import-column-instance graph table data)))
                (tx-make-r-column_column-instance graph column column-instance)
                (tx-make-r-table_column-instance graph table column-instance)
                column-instance))
          (tx-import-columns graph table (cdr columns-data)))))

(defun tx-import-make-table (graph plist)
  (let* ((data (get-table-plist plist))
         (name (getf data :name)))
    (tx-make-table graph
                    (make-table-code name)
                    name)))

(defun %tx-import-foreign-key (graph from-table plist)
  (let* ((to-table-code (make-table-code (getf (getf plist :foreign-key) :references)))
         (to-table (get-table graph :code to-table-code))
         (to-code (make-column-instance-code to-table "id" "integer")))
    (values (get-table-column-instance graph from-table :data plist)
            (get-table-column-instance graph to-table :code to-code))))

(defun tx-import-foreign-key (graph from-table plist)
  (multiple-value-bind (from-column-instance to-column-instance)
      (%tx-import-foreign-key graph from-table plist)
    (let ((from-port (add-port-er graph from-column-instance))
          (to-port (add-port-er graph to-column-instance)))
      (shinra:tx-make-edge graph 'edge-er from-port to-port :r))))

(defun tx-import-foreign-keys (graph table plist)
  (dolist (fka (find-foreign-key-plists plist))
    (tx-import-foreign-key graph table fka)))

(defun get-id-column-instance (graph table)
  (find-if #'(lambda (attr)
               (eq (code attr)
                   (make-column-instance-code table "id" "integer")))
           (shinra:find-r-vertex graph 'edge-er
                                 :from table)))

(defun tx-import-tables (graph plist)
  (let ((table (tx-import-make-table graph plist))
        (columns-data (cons '(:type :column :alias "t" :name "id" :data-type "integer")
                               (find-column-plists plist))))
    (tx-import-columns graph table columns-data)
    table))

(defun tx-import-all-foreign-keys (graph plist)
  (when-let ((data (car plist)))
    (let* ((table-name (getf (get-table-plist data) :name))
           (table-code (make-table-code table-name))
           (table (get-table graph :code table-code)))
      (tx-import-foreign-keys graph table data))
    (tx-import-all-foreign-keys graph (cdr plist))))

;;;;;
;;;;; main
;;;;;
(defun %import-schema.rb (graph plists)
  (when-let ((plist (car plists)))
    (let ((tables (cons (up:execute-transaction (tx-import-tables graph plist))
                        (%import-schema.rb graph (cdr plists)))))
      (tx-import-all-foreign-keys graph plists)
      tables)))

(defun import-schema.rb (graph pathname)
  (%import-schema.rb graph (ter.parser:parse-schema.rb pathname)))
