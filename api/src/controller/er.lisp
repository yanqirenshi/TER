(in-package :ter.api.controller)

(defun finder-er-tables ()
  (ter:find-table ter.db:*graph*))

(defun finder-er-columns ()
  (ter:find-column ter.db:*graph*))

(defun finder-er-column-instances ()
  (ter:find-column-instance ter.db:*graph*))

(defun finder-er-relashonships ()
  (ter:find-er-all-edges ter.db:*graph*))

(defun find-er-all-nodes ()
  (nconc '()
         (finder-er-tables)
         (finder-er-columns)
         (finder-er-column-instances)))

(defun find-er ()
  (list :tables (finder-er-tables)
        :columns (finder-er-columns)
        :column_instances (finder-er-column-instances)
        :relashonships (finder-er-relashonships)))
