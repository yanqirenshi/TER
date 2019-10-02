(in-package :ter)


(defun find-force (graph &key modeler)
  (if modeler
      (shinra:find-r-vertex graph 'edge-force :to modeler :vertex-class 'force :edge-type :have-to)
      (find-vertex graph 'force)))


(defun get-force (graph &key %id code)
  (let ((target-class 'force))
    (cond (code
           (find-vertex graph target-class :slot 'code :value code))
          (%id
           (shinra:get-vertex-at graph target-class :%id %id)))))


(defun assert-force-code (code)
  (assert (find code *force-codes*)))


(defun tx-make-force (graph code &key (name "") (description ""))
  (assert graph)
  (assert-force-code code)
  (assert (null (get-force graph :code code)))
  (tx-make-vertex graph
                  'force
                  `((code ,code)
                    (name ,name)
                    (description ,description))))


(defun tx-ensure-force (graph code)
  (or (get-force graph :code code)
      (tx-make-force graph code)))


(defun tx-ensure-forces (graph)
  (mapcar #'(lambda (code)
              (tx-ensure-force graph code))
          *force-codes*))
