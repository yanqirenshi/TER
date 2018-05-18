(in-package :ter)

(defun get-r-entity_attribute-entity (graph entity attribute-entity)
  (find-if #'(lambda (r)
               (string= (code r) (code attribute-entity)))
           (shinra:find-r-vertex graph 'shinra:ra
                                 :from entity
                                 :vertex-class 'attribute-entity
                                 :edge-type :have)))

(defun get-r-attribute_attribute-entity (graph attribute attribute-entity)
  (find-if #'(lambda (r)
               (string= (code r) (code attribute-entity)))
           (shinra:find-r-vertex graph 'shinra:ra
                                 :from attribute
                                 :vertex-class 'attribute-entity
                                 :edge-type :instance-of)))

(defun tx-make-r-attribute_attribute-entity (graph attribute attribute-entity)
  (or (get-r-attribute_attribute-entity graph attribute attribute-entity)
      (tx-make-edge graph 'shinra:ra attribute attribute-entity :instance-of)))

(defun tx-make-r-entity_attribute-entity (graph entity attribute-entity)
  (or (get-r-entity_attribute-entity graph entity attribute-entity)
      (tx-make-edge graph 'shinra:ra entity attribute-entity :have)))
