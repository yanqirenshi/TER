(in-package :ter)

(defun find-attribute (graph)
  (shinra:find-vertex graph 'attribute))

(defun get-attribute (graph &key code)
  (car (shinra:find-vertex graph 'attribute :slot 'code :value code)))

(defun tx-make-attribute (graph code name data-type)
  (or (get-attribute graph :code code)
      (shinra:tx-make-vertex graph
                             'attribute
                             `((code ,code)
                               (name ,name)
                               (data-type ,data-type)))))
