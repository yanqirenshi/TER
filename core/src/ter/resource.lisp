(in-package :ter)

(defun find-resource (graph)
  (shinra:find-vertex graph 'resource))

(defun get-resource (graph &key code)
  (car (shinra:find-vertex graph 'resource :slot 'code :value code)))

(defun tx-make-resource (graph code name)
  (or (get-resource graph :code code)
      (shinra:tx-make-vertex graph
                             'resource
                             `((code ,code)
                               (name ,name)))))
