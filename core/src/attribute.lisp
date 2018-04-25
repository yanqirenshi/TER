(in-package :ter)

(defun tx-make-attribute (graph name data-type)
  (shinra:tx-make-vertex graph 'attribute
                         `((name ,name)
                           (data-type ,data-type))))
