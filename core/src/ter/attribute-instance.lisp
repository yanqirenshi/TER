(in-package :ter)

(defun find-attribute-instance (graph)
  (shinra:find-vertex graph 'attribute-instance))

(defun get-attribute-instance (graph &key code)
  (car (shinra:find-vertex graph 'attribute-instance :slot 'code :value code)))

(defun tx-make-attribute-instance (graph code name data-type &key (description ""))
  (or (get-attribute-instance graph :code code)
      (shinra:tx-make-vertex graph
                             'attribute-instance
                             `((code ,code)
                               (name ,name)
                               (data-type ,data-type)
                               (description ,description)))))
