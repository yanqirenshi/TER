(in-package :ter.parser)

(defun trim (str)
  (string-trim '(#\Space #\Tab #\Newline) str))

;;;
;;; column-line
;;;
(defun split-column-line (line)
  (let ((pos (position #\, line)))
    (if (not pos)
        (values line "")
        (values (trim (subseq line 0 pos))
                (trim (subseq line (+ 1 pos)))))))

(defun parse-column-line-constant (line)
  (multiple-value-bind (ret arr)
      (cl-ppcre:scan-to-strings "^(.+)\\.(.+)\\s+\"(.+)\"$"
                                line)
    (when ret
        (list :type :column
              :alias (trim (aref arr 0))
              :name (trim (aref arr 2))
              :data-type (trim (aref arr 1))))))

(defun rm-dbl-quote (str)
  (multiple-value-bind (ret arr)
      (cl-ppcre:scan-to-strings "\"(.*)\"" str)
    (if ret (aref arr 0) str)))

(defun parse-column-line-foreign-key-item (line)
  (let ((pos (position #\: line)))
    (list (alexandria:make-keyword (string-upcase (trim (subseq line 0 pos))))
          (rm-dbl-quote (trim (subseq line (+ 1 pos)))))))

(defun parse-column-line-foreign-key-items (lines)
  (alexandria:when-let ((line (car lines)))
    (nconc (parse-column-line-foreign-key-item line)
           (parse-column-line-foreign-key-items (cdr lines)))))

(defun parse-column-line-foreign-key (line)
  (multiple-value-bind (ret arr)
      (cl-ppcre:scan-to-strings "foreign_key:\\s*{([^}]+)}.*" line)
    (when ret
      (list :foreign-key
            (parse-column-line-foreign-key-items (split-sequence:split-sequence #\, (aref arr 0)))))))

(defun parse-column-line-limit (line)
  (multiple-value-bind (ret arr)
      (cl-ppcre:scan-to-strings ".*limit:\\s+([\\d|^,]+),.*" line)
    (when ret
      (list :limit (aref arr 0)))))

(defun parse-column-line (line)
  (multiple-value-bind (constant options)
      (split-column-line line)
    (nconc (nconc (parse-column-line-constant constant)
                  (parse-column-line-foreign-key options))
           (parse-column-line-limit line))))

;;;
;;; table lines
;;;
(defun table-line-start-p (line)
  (multiple-value-bind (ret arr)
      (cl-ppcre:scan-to-strings "^create_table\\s+\"(.+)\",(.*)\\|(.+)\\|$"
                                (trim line))
    (when ret
      (list :type :table-start
            :name (aref arr 0)
            :options (aref arr 1)
            :alias (aref arr 2)))))

(defun table-line-end-p (line)
  (when (cl-ppcre:scan "^end$" (trim line))
    (list :type :block-end)))

(defun add-index-line-p (line)
  (when (cl-ppcre:scan "^add_index.*$" (trim line))
    (list :type :add-index :line line)))

(defun add-foreign-key-line-p (line)
  (when (cl-ppcre:scan "^add_foreign_key.*$" (trim line))
    (list :type :add-foreign-key :line line)))

(defun add-comment-line-p (line)
  (when (cl-ppcre:scan "^#.*$" (trim line))
    (list :type :comment :line line)))

(defun add-empty-line-p (line)
  (when (string= "" (trim line))
    (list :type :empty :line line)))


(defun parse-shcema.rb-line (line)
  (or (table-line-start-p line)
      (table-line-end-p line)
      (add-index-line-p line)
      (add-foreign-key-line-p line)
      (add-comment-line-p line)
      (add-empty-line-p line)
      (list :type :other :line line)))

(defun %split-lines-by-table (line-plist table tables)
  (cond ((eq :table-start (getf line-plist :type))
         (values (list line-plist) tables))
        ((eq :block-end (getf line-plist :type))
         (progn (if (not table)
                    (values nil tables)
                    (progn
                      (push line-plist table)
                      (values nil
                              (if tables
                                  (progn
                                    (push (reverse table) tables))
                                  (list (reverse table))))))))
        ((eq :other (getf line-plist :type))
         (if table
             (progn (push (parse-column-line (getf line-plist :line)) table)
                    (values table tables))
             (values table tables)))))

(defun stream2line-plists (s)
  (let ((line (read-line s nil :end-of-file)))
    (unless (eq line :end-of-file)
      (cons (parse-shcema.rb-line line)
            (stream2line-plists s)))))

(defun split-line-plists (line-plists &optional tables keys)
  (if (null line-plists)
      (values (reverse tables) (reverse keys))
      (let* ((line-plist (car line-plists))
             (line-type (getf line-plist :type)))
        (cond ((or (eq line-type :add-foreign-key)
                   (eq line-type :add-index))
               (push line-plist keys))
              ((or (eq line-type :table-start)
                   (eq line-type :block-end)
                   (eq line-type :other))
               (push line-plist tables)))
        (split-line-plists (cdr line-plists) tables keys))))

(defun split-lines-by-table (line-plists &optional table tables)
  (if (null line-plists)
      tables
      (let ((line-plist (car line-plists)))
        (multiple-value-bind (next-table next-tables)
            (%split-lines-by-table line-plist
                                   table
                                   tables)
          (split-lines-by-table (cdr line-plists) next-table next-tables)))))

;;;
;;; main
;;;
(defun parse-schema.rb (pathname)
  (with-open-file (s pathname)
    (multiple-value-bind (table-plists key-plists)
        (split-line-plists (stream2line-plists s))
      (values (split-lines-by-table table-plists)
              key-plists))))


;;(parse-schema.rb "~/prj/cw-rbr_cms/db/schema.rb")

;; 1. entity を全部登録
;; 2. column を全部登録
;; 3. entity-column を全部登録
;; 4. forign key を全部登録
