(in-package :ter)

(defun find-column (graph)
  (shinra:find-vertex graph 'column))

(defun get-column (graph &key code)
  (car (shinra:find-vertex graph 'column :slot 'code :value code)))

(defun tx-make-column (graph code name data-type)
  (or (get-column graph :code code)
      (shinra:tx-make-vertex graph
                             'column
                             `((code ,code)
                               (name ,name)
                               (data-type ,data-type)))))
