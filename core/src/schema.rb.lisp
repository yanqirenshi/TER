(in-package :ter)

(defvar *schema.rb-pathname* nil)

;;;
;;; parse-line
;;;
(defparameter *line-patterns*
  `((:code :table             :regex "^create_table \"(\\S+)\",\\s+(.*)$"
     :func ,#'(lambda (arr) (list :code (aref arr 0)
                                  :name (aref arr 0)
                                  :opts (aref arr 1)
                                  :class :table)))
    (:codd :col-with-param    :regex "^t\\.(\\S+)\\s+\"(\\S+)\",\\s+(.*)$"
     :func ,#'(lambda (arr) (list :code (concatenate 'string (aref arr 1) "@" (aref arr 0))
                                  :name (aref arr 1)
                                  :type (aref arr 0)
                                  :opts (aref arr 2)
                                  :class :col-with-param)))
    (:codd :col-without-param :regex "^t\\.(\\S+)\\s+\"(\\S+)\"$"
     :func ,#'(lambda (arr) (list :code (concatenate 'string (aref arr 1) "@" (aref arr 0))
                                  :name (aref arr 1)
                                  :type (aref arr 0)
                                  :opts nil
                                  :class :col-without-param)))))

(defun get-pattern (line &optional (patterns *line-patterns*))
  (find-if #'(lambda (ptn)
               (cl-ppcre:scan-to-strings (getf ptn :regex) line))
           patterns))

(defun parse-line (line &optional (patterns *line-patterns*))
  (when-let ((ptn (car patterns)))
    (multiple-value-bind (ret arr)
        (cl-ppcre:scan-to-strings (getf ptn :regex) line)
      (if ret
          (funcall (getf ptn :func) arr)
          (parse-line line (cdr patterns))))))

;;;
;;; cleaning
;;;
(defun skip-line-p (line)
  (let ((line-trim (string-trim '(#\Space #\Tab #\Newline) line)))
    (or (string= "" line-trim)
        (string= "end" line-trim)
        (string= "#" (subseq line-trim 0 1))
        (cl-ppcre:scan "^add_index.*$" line-trim)
        (cl-ppcre:scan "^ActiveRecord::.*$" line-trim)
        (cl-ppcre:scan "^enable_extension.*$" line-trim))))

(defun cleaning-schema.rb (s)
  (when-let ((line (read-line s nil nil)))
    (if (skip-line-p line)
        (cleaning-schema.rb s)
        (cons (let ((d (parse-line (string-trim '(#\Space #\Tab #\Newline) line))))
                (unless d (print line))
                d)
              (cleaning-schema.rb s)))))

;;;
;;; spliter
;;;
(defun split-table-lines (line-list)
  (let ((out nil)
        (table nil)
        (attributes nil))
    (dolist (line line-list)
      (if (eq :table (getf line :class))
          (progn
            (when table
              (push (nconc table
                           (list :attributes (reverse attributes)))
                    out))
            (setf table line)
            (setf attributes nil))
          (push line attributes)))
    (reverse out)))

;;;
;;; loader
;;;
(defun schema.rb2plist (&key (file *schema.rb-pathname*))
  (with-open-file (s file)
    (split-table-lines
     (cleaning-schema.rb s))))

;;;
;;; graph (db)
;;;
(defun tx-import-make-attributes (graph attributes)
  (when-let ((attr (car attributes)))
    (cons (tx-make-attribute graph
                             (getf attr :code)
                             (getf attr :name)
                             (getf attr :type))
          (tx-import-make-attributes graph (cdr attributes)))))

(defun tx-import-make-entity (graph data)
  (let ((entity (tx-make-entity graph
                                (getf data :code)
                                (getf data :name)))
        (attributes (tx-import-make-attributes graph
                                               (getf data :attributes))))
    (tx-make-r-entity-attributes graph
                                 entity
                                 attributes)
    entity))

(defun import-schema.rb (graph &optional (schema-data (schema.rb2plist)))
  (when-let ((data (car schema-data)))
    (cons (tx-import-make-entity graph data)
          (import-schema.rb graph (cdr schema-data)))))
