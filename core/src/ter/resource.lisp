(in-package :ter)

(defun find-resource (graph)
  (shinra:find-vertex graph 'resource))


(defun get-resource (graph &key code)
  (car (shinra:find-vertex graph 'resource :slot 'code :value code)))


(defun tx-make-resource-core
    (graph class-symbol code name &key
                                    (description "")
                                    (location (make-instance 'point)))
  (or (get-resource graph :code code)
      (shinra:tx-make-vertex graph
                             class-symbol
                             `((code ,code)
                               (name ,name)
                               (description ,description)
                               (location ,location)))))


(defun tx-make-resource
    (graph code name &key
                       (description "")
                       (location (make-instance 'point)))
  (tx-make-resource-core graph 'resource code name :description description :location location))


(defun tx-make-resource-subset
    (graph code name &key
                       (description "")
                       (location (make-instance 'point)))
  (tx-make-resource-core graph 'resource-subset code name :description description :location location))
