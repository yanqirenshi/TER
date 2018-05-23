(in-package :ter)

(defun find-comparative (graph)
  (shinra:find-vertex graph 'comparative))

(defun get-comparative (graph &key code)
  (car (shinra:find-vertex graph 'comparative :slot 'code :value code)))

(defun tx-make-comparative (graph code name data-type)
  (or (get-comparative graph :code code)
      (shinra:tx-make-vertex graph
                             'comparative
                             `((code ,code)
                               (name ,name)
                               (data-type ,data-type)))))
