(in-package :ter)


(defgeneric table-column-instances-port (graph type table column)
  (:method ((graph shinra:banshou) type (table-code symbol) (column-code symbol))
    (let ((column-instance (table-column-instance graph table-code column-code)))
      (if (null column-instance)
          (warn "Not found column instance. column-code=~a" column-code)
          (column-instance-port graph column-instance type :ensure t)))))
