(in-package :ter)

(defun get-r-entity-attribute (graph entity attribute)
  (find-if #'(lambda (r)
               (string= (code r) (code attribute)))
           (shinra:find-r-vertex graph 'shinra:ra
                                 :from entity
                                 :vertex-class 'attribute
                                 :edge-type :have)))

(defun tx-make-r-entity-attributes (graph entity attributes)
  (when-let ((attribute (car attributes)))
    (unless (get-r-entity-attribute graph entity attribute)
      (tx-make-edge graph 'shinra:ra entity attribute :have))
    (tx-make-r-entity-attributes graph entity (cdr attributes))))
