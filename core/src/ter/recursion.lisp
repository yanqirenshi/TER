(in-package :ter)

(defun find-recursion (graph)
  (shinra:find-vertex graph 'recursion))

(defun get-recursion (graph &key code)
  (car (shinra:find-vertex graph 'recursion :slot 'code :value code)))

(defun tx-make-recursion (graph code name data-type)
  (or (get-recursion graph :code code)
      (shinra:tx-make-vertex graph
                             'recursion
                             `((code ,code)
                               (name ,name)
                               (data-type ,data-type)))))
