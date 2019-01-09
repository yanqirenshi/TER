(in-package :ter)

(defun find-event (graph)
  (shinra:find-vertex graph 'event))

(defun get-event (graph &key code)
  (car (shinra:find-vertex graph 'event :slot 'code :value code)))

(defun tx-make-event (graph code name &key
                                        (description "")
                                        (location (make-instance 'point)))
  (or (get-event graph :code code)
      (shinra:tx-make-vertex graph
                             'event
                             `((code ,code)
                               (name ,name)
                               (description ,description)
                               (location ,location)))))
