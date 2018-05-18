(in-package :ter)

(defun find-entitiy (graph)
  (find-vertex graph 'entity))

(defun get-entity (graph &key code (with-attributes t))
  (let ((entity (car (find-vertex graph 'entity :slot 'code :value code))))
    (when entity
      (when with-attributes
        (setf (attributes entity)
              (find-entity-attributes *graph* entity)))
      entity)))

(defun tx-make-entity (graph code name)
  (or (get-entity graph :code code)
      (tx-make-vertex graph
                      'entity
                      `((code ,code)
                        (name ,name)))))

(defun find-entity-attributes (graph entity)
  (shinra:find-r-vertex graph 'shinra:ra
                        :from entity
                        :vertex-class 'attribute
                        :edge-type :have))
