(in-package :ter)

(defun print-table (graph code)
  (let ((table (get-table graph :code code)))
    (format t "CODE: ~S~%" (code table))
    (format t "NAME: ~a~%~%" (name table))
    (format t "<<Columns>>~%")
    (plist-printer:pprints
     (mapcar #'(lambda (d)
                 (list :%id (up:%id d)
                       :name (name d)
                       :type (data-type d)
                       :col-type (column-type d)
                       :description (description d)))
             (sort (columns table)
                   #'(lambda (a b) (- (up:%id a) (up:%id b)))))
     (list :%id :name :type :col-type :description))))


(defun set-column-type (%id column-type)
  (setf (column-type (get-column-instance *graph* :%id %id))
        column-type))
