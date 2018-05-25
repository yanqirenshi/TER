(in-package :ter.api.controller)

(defun finder-er-tables ()
  (ter:find-table ter.db:*graph*))

(defun finder-er-columns ()
  (ter:find-column ter.db:*graph*))

(defun finder-er-column-instances ()
  (ter:find-column-instance ter.db:*graph*))

(defun finder-er-relashonships ()
  (ter:find-er-all-edges ter.db:*graph*))
