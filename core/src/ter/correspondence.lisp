(in-package :ter)

(defun find-correspondence (graph)
  (shinra:find-vertex graph 'correspondence))

(defun get-correspondence (graph &key %id code)
  (cond (%id (shinra:get-vertex-at graph 'correspondence :%id %id))
        (code (car (shinra:find-vertex graph 'correspondence :slot 'code :value code)))))

(defun tx-make-correspondence (graph code name data-type)
  (or (get-correspondence graph :code code)
      (shinra:tx-make-vertex graph
                             'correspondence
                             `((code ,code)
                               (name ,name)
                               (data-type ,data-type)))))
