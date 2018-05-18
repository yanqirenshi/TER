(in-package :ter)

(defun find-attribute-entity (graph)
  (find-vertex graph 'attribute-entity))

(defun get-attribute-entity (graph &key code)
  (car (find-vertex graph 'attribute-entity :slot 'code :value code)))

(defun tx-make-attribute-entity (graph code name data-type)
  (or (get-attribute-entity graph :code code)
      (tx-make-vertex graph
                      'attribute-entity
                      `((code ,code)
                        (name ,name)
                        (data-type ,data-type)))))
