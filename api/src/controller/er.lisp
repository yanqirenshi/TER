(in-package :ter.api.controller)

(defun finder-er-entities ()
  (ter:find-entitiy ter.db:*graph*))

(defun finder-er-attributes ()
  (ter:find-attribute ter.db:*graph*))

(defun finder-er-attribute-entitis ()
  (ter:find-attribute-entity ter.db:*graph*))

(defun finder-er-relashonships ()
  (ter:find-all-edges ter.db:*graph*))
