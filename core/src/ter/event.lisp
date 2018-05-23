(in-package :ter)

(defun find-event (graph)
  (shinra:find-vertex graph 'event))

(defun get-event (graph &key code)
  (car (shinra:find-vertex graph 'event :slot 'code :value code)))

(defun tx-make-event (graph code name data-type)
  (or (get-event graph :code code)
      (shinra:tx-make-vertex graph
                             'event
                             `((code ,code)
                               (name ,name)
                               (data-type ,data-type)))))
