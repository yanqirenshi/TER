(in-package :ter)

(defun import-foreign-keys (graph plists)
  (when-let ((plist (car plists)))
    (let ((port-out (table-column-instances-port graph :out (getf plist :from-table) (getf plist :from-column)))
          (port-in  (table-column-instances-port graph :in  (getf plist :to-table)   (getf plist :to-column))))
      (tx-make-r-port-er graph port-out port-in)
      (import-foreign-keys graph (cdr plists)))))

(defun import-tables (graph plists)
  (when-let ((plist (car plists)))
    (let ((tables (cons (up:execute-transaction (tx-import-tables graph plist))
                        (import-tables graph (cdr plists)))))
      tables)))

(defun import-schema.rb (graph pathname)
  (multiple-value-bind (tables keys)
      (ter.parser:parse-schema.rb pathname)
    (import-tables graph tables)
    (import-foreign-keys graph
                         (nconc (tables2import-fk-datas tables)
                                (keys2import-fk-datas keys)))))
