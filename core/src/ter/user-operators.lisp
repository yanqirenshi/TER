(in-package :ter)


(defun tx-add-identifier-2-entity (graph campus-code entity-code &key code name data-type)
  (let* ((campus (ter:get-campus graph :code campus-code))
         (graph (ter::get-campus-graph campus)))
    (let ((entity (get-resource graph :code entity-code)))
      (assert entity)
      (tx-add-identifier-instance graph
                                  entity
                                  (list :code code :name name :data-type data-type)))))


(defun tx-add-attribute-2-entity (graph &key campus-code entity-code code name data-type)
  (let* ((campus (ter:get-campus graph :code campus-code))
         (graph (ter::get-campus-graph campus)))
    (let ((entity (or (get-resource graph :code entity-code)
                      (get-event    graph :code entity-code))))
      (assert entity)
      (tx-add-attribute-instance graph entity
                                 (list :code code :name name :data-type data-type)))))
