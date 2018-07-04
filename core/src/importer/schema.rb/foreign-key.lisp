(in-package :ter)


;;;;;
;;;;; Parsed list to Import data list
;;;;;
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

(defun foreign-key-column-code (type table-code options)
  (let ((options-column (getf options :column))
        (options-primary-key (getf options :primary_key)))
    (cond ((eq :from type)
           (if (and options-column options-primary-key)
               options-column
               "id"))
          ((eq :to type)
           (or options-column
               (make-fk-id-column table-code))))))

(defun parse-add-foreign-key-line (line)
  (multiple-value-bind (ret arr)
      (cl-ppcre:scan-to-strings  "^add_foreign_key\\s+(.*)$" (string-trim '(#\Space #\Tab #\Newline) line))
    (unless ret (warn "~S がパース出来ませんでした。" line))
    (let* ((items           (split-sequence:split-sequence #\, (aref arr 0)))
           (options         (parse-foreign-key-options (cddr items)))
           (table-code-from (str2keyword (get-value-string (second items))))
           (table-code-to   (str2keyword (get-value-string (first items)))))
      `(:from (:table ,table-code-from :columns ,(foreign-key-column-code :from table-code-from options))
        :to   (:table ,table-code-to   :columns ,(foreign-key-column-code :to   table-code-to   options))))))

(defun parse-add-foreign-key-line (line)
  (multiple-value-bind (ret arr)
      (cl-ppcre:scan-to-strings  "^add_foreign_key\\s+(.*)$" (string-trim '(#\Space #\Tab #\Newline) line))
    (unless ret (warn "~S がパース出来ませんでした。" line))
    (let* ((items           (split-sequence:split-sequence #\, (aref arr 0)))
           (options         (parse-foreign-key-options (cddr items)))
           (table-code-from (get-value-string (second items)))
           (table-code-to   (get-value-string (first items))))
      (list :type :add-foreign-key
            :table-from table-code-from
            :table-to table-code-to
            :options options))))

;;;
;;; add-foreign-key 2 import-data
;;
(defun add-foreign-key2import-data (add-foreign-key)
  (let* ((contents (getf add-foreign-key :contents))
         (column (getf (getf contents :options) :column)))
    (let ((from-table (getf contents :table-from)))
      (list :from-table  (str2keyword from-table)
            :from-column (or (str2keyword column) :id)
            :to-table    (str2keyword (getf contents :table-to))
            :to-column   (str2keyword (or column
                                          (make-fk-id-column from-table)))))))

(defun add-foreign-key2import-data (add-foreign-key)
  (let* ((contents (getf add-foreign-key :contents)))
    (make-import-fk-data (getf contents :table-from)
                         :id
                         (getf contents :table-to)
                         (getf contents :options))))


(defun keys2import-fk-datas (keys)
  (when-let ((it (car keys)))
    (if (not (eq (getf it :type) :add-foreign-key))
        (keys2import-fk-datas (cdr keys))
        (cons (add-foreign-key2import-data it)
              (keys2import-fk-datas (cdr keys))))))

;;;;;
;;;;; Import
;;;;;
(defgeneric make-foreign-key (graph from to)
  ;; column port
  (:method (graph (from port-er-out) (to port-er-in))
    (tx-make-r-port-er graph from to))
  ;; column instance
  (:method (graph (from column-instance) (to column-instance))
    (make-foreign-key graph
                      (get-column-instance-port graph from :out)
                      (get-column-instance-port graph to   :in)))
  ;; list
  (:method (graph (from-list list) (to-list list))
    (make-foreign-key graph
                      (apply #'table-column-instance graph from-list)
                      (apply #'table-column-instance graph to-list))))

(defun import-foreign-key (graph line)
  (multiple-value-bind (ret arr)
      (cl-ppcre:scan-to-strings  "^add_foreign_key\\s+(.*)$" (string-trim '(#\Space #\Tab #\Newline) line))
    (unless ret (warn "~S がパース出来ませんでした。" line))
    (let* ((items                     (split-sequence:split-sequence #\, (aref arr 0)))
           (options                   (parse-foreign-key-options (cddr items)))
           (table-code-from           (str2keyword (get-value-string (second items))))
           (table-code-to             (str2keyword (get-value-string (first items))))
           (column-instance-code-from (foreign-key-column-code :from table-code-from options))
           (column-instance-code-to   (foreign-key-column-code :to   table-code-to   options)))
      (make-foreign-key graph
                        (list table-code-from column-instance-code-from)
                        (list table-code-to   column-instance-code-to)))))
