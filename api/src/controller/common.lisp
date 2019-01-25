(in-package :ter.api.controller)

;;;;;
;;;;; snapshot
;;;;;
(defun snapshot-all-schema ()
  (dolist (schema (ter::find-schema ter.db:*graph*))
    (let ((graph (ter::get-schema-graph schema)))
      (when graph
        (up:snapshot ter.db:*graph*)))))

(defun snapshot-all ()
  (up:snapshot ter.db:*graph*)
  (snapshot-all-schema))
