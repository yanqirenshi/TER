(in-package :ter)

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
