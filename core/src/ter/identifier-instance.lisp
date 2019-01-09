(in-package :ter)

(defun find-identifier-instance (graph)
  (shinra:find-vertex graph 'identifier-instance))

(defun get-identifier-instance (graph &key code)
  (car (shinra:find-vertex graph 'identifier-instance :slot 'code :value code)))

(defun tx-make-identifier-instance (graph code name data-type)
  (shinra:tx-make-vertex graph
                         'identifier-instance
                         `((code ,code)
                           (name ,name)
                           (data-type ,data-type))))
