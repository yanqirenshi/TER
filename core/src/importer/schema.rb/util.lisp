(in-package :ter)

(defun get-value-string (value)
  (multiple-value-bind (ret arr)
      (cl-ppcre:scan-to-strings  "^\"(.*)\"$" (string-trim '(#\Space #\Tab #\Newline) value))
    (unless ret (warn "~S がパース出来ませんでした。" value))
    (if ret (aref arr 0) nil)))

(defun str2keyword (str)
  (when str
    (alexandria:make-keyword (string-upcase str))))

(defun make-fk-id-column (table-code)
  (concatenate 'string (string-downcase (cl-inflector:singular-of table-code)) "_id"))


;;;
;;; CODE
;;;
(defun make-code (&rest strs)
  (alexandria:make-keyword (string-upcase (apply #'concatenate 'string strs))))

(defun make-table-code (name)
  (make-code name))

(defun make-column-code (name data-type)
  (make-code name "@" data-type))

(defun to_string (v)
  (cond ((table-p v) (to_string (code v)))
        ((symbolp v) (symbol-name v))
        ((stringp v) v)
        (t (error "nan no mono? v=~a" v))))

(defun make-column-instance-code (table name)
  (make-code (to_string table) "." (to_string name)))

;;;
;;; type
;;;
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


;;;
;;; import fk data
;;;
(defun make-import-fk-data (from-table from-column to-table &optional options)
  (let ((column (getf options :column)))
    (list :from-table  (str2keyword from-table)
          :from-column (str2keyword (or column from-column))
          :to-table    (str2keyword to-table)
          :to-column   (str2keyword (or column (make-fk-id-column from-table))))))
