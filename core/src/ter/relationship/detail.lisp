(in-package :ter)

(defgeneric tx-add-detail (graph entity)
  (:method (graph (entity resource))
    (list graph entity))
  (:method (graph (entity event))
    (list graph entity)))
