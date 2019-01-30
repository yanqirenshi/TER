(in-package :ter)

(defun find-systems (graph)
  (shinra:find-vertex graph 'system))

(defun get-system (graph &key code)
  (car (shinra:find-vertex graph 'system
                            :slot  'code
                            :value code)))

(defun tx-make-system (graph code &key name)
  (assert (keywordp code))
  (assert (null (get-system graph :code code)))
  (shinra:tx-make-vertex graph 'system
                         `((code ,code)
                           (name ,name))))
