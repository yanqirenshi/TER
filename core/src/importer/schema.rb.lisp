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

(defun make-column-instance-code (table name)
  (make-code (symbol-name (code table)) "." name))

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
         (code (make-column-instance-code table name)))
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
         (to-code (make-column-instance-code to-table "id")))
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
                   (make-column-instance-code table "id")))
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

(defun get-value-string (value)
  (multiple-value-bind (ret arr)
      (cl-ppcre:scan-to-strings  "^\"(.*)\"$" (string-trim '(#\Space #\Tab #\Newline) value))
    (unless ret (warn "~S がパース出来ませんでした。" value))
    (if ret (aref arr 0) nil)))

(defun str2keyword (str)
  (alexandria:make-keyword (string-upcase str)))

(defun parse-foreign-key-options (options)
  (when-let ((option (car options)))
    (multiple-value-bind (ret arr)
        (cl-ppcre:scan-to-strings  "^(\\S+):\\s+(\\S+)$" (string-trim '(#\Space #\Tab #\Newline) option))
      (unless ret (warn "~S がパース出来ませんでした。" option))
      (if (not ret)
          (parse-foreign-key-options (cdr options))
          (nconc (list (str2keyword (aref arr 0))
                       (get-value-string (aref arr 1)))
                 (parse-foreign-key-options (cdr options)))))))



(defun parse-foreign-key-line-column-code (type table-name options)
  (let ((options-column (getf options :column))
        (options-primary-key (getf options :primary_key)))
    (cond ((eq :from type)
           (if (and options-column options-primary-key)
               options-column
               "id"))
          ((eq :to type)
           (or options-column
               (concatenate 'string (cl-inflector:singular-of table-name) "_id"))))))

(defun parse-foreign-key-line (graph line)
  (multiple-value-bind (ret arr)
      (cl-ppcre:scan-to-strings  "^add_foreign_key\\s+(.*)$" (string-trim '(#\Space #\Tab #\Newline) line))
    (unless ret
      (warn "~S がパース出来ませんでした。" line))
    (let* ((items (split-sequence:split-sequence #\, (aref arr 0)))
           (table-name-to   (get-value-string (first items)))
           (table-name-from (get-value-string (second items)))
           (options (parse-foreign-key-options (cddr items)))
           (table-from (get-table graph :code (str2keyword table-name-from)))
           (table-to (get-table graph :code (str2keyword table-name-to)))
           (column-code-from (make-column-instance-code table-from (parse-foreign-key-line-column-code :from table-name-from options)))
           (column-code-to   (make-column-instance-code table-to   (parse-foreign-key-line-column-code :to   table-name-from options))))
      ;;
      ;; TODO: これで関係をさくせいする。
      ;;
      (list :table-from      table-from
            :table-to        table-to
            :table-from-port (get-table-column-instances-port graph table-from column-code-from)
            :table-to-port   (get-table-column-instances-port graph table-to   column-code-to)))))

(defun import-keys (graph plists)
  (when-let ((plist (car plists)))
    (if (eq :add-foreign-key (getf plist :type))
        (cons (parse-foreign-key-line graph (getf plist :line))
              (import-keys graph (cdr plists)))
        (import-keys graph (cdr plists)))))

(defun import-schema.rb (graph pathname)
  (multiple-value-bind (tables keys)
      (ter.parser:parse-schema.rb pathname)
    (plist-printer:pprints (import-keys graph keys)
                           '( :table-from :table-to :table-from-port :table-to-port :options))
    (%import-schema.rb graph tables)))
