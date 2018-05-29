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
        :relashonships (finder-er-relashonships)
        :ports (ter::find-port-er ter.db:*graph*)
        :edges (ter:find-er-all-edges ter.db:*graph*)))

(defun save-er-position (code position)
  (let ((table (ter::get-table ter.db:*graph* :code code)))
    (unless table (caveman2:throw-code 404))
    (ter::save-position ter.db:*graph* table position)))
