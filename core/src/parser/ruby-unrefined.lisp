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

(defun parse-shcema.rb-line (line)
  (or (table-line-start-p line)
      (table-line-end-p line)
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

(defun split-lines-by-table (s &optional table tables)
  "ラインをテーブルごとに分割する。
分割するときにラインを plist に置き換える。"
  (let ((line (read-line s nil :end-of-file)))
    (if (eq line :end-of-file)
        tables
        (multiple-value-bind (next-table next-tables)
            (%split-lines-by-table (parse-shcema.rb-line line)
                                   table
                                   tables)
          (split-lines-by-table s next-table next-tables)))))

;;;
;;; main
;;;
(defun parse-schema.rb (pathname)
  (with-open-file (s pathname)
    (split-lines-by-table s)))

;;(parse-schema.rb "~/prj/cw-rbr_cms/db/schema.rb")

;; 1. entity を全部登録
;; 2. column を全部登録
;; 3. entity-column を全部登録
;; 4. forign key を全部登録
