(in-package :ter.api.controller)

(defun environments ()
  (list :schemas (ter::find-schema ter.db:*graph*)
        :er `(:schema (:active ,(ter::config :er :schema :active)))))

(defun set-active-schema (schema)
  (setf (ter::config :er :schema :active) (ter::code schema))
  (environments))
