(in-package :ter)

(defun find-identifier (graph)
  (shinra:find-vertex graph 'identifier))

(defun get-identifier (graph &key code)
  (car (shinra:find-vertex graph 'identifier :slot 'code :value code)))

(defun tx-make-identifier (graph code name data-type)
  (or (get-identifier graph :code code)
      (shinra:tx-make-vertex graph
                             'identifier
                             `((code ,code)
                               (name ,name)
                               (data-type ,data-type)))))
