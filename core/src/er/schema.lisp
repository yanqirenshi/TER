(in-package :ter)

(defun find-schema (graph)
  (shinra:find-vertex graph 'schema))

(defun get-schema (graph)
  (car (shinra:find-vertex graph 'schema)))

(defgeneric tx-make-schema (graph code &key name description)
  (:method (graph code &key name description)
    (assert (not (get-schema graph)))
    (shinra:tx-make-vertex graph 'schema
                           `((code ,code)
                             (name ,name )
                             (description ,description)))))
