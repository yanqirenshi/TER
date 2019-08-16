(in-package :ter)

(defgeneric tx-add-recursion (graph entity)
  (:method (graph (entity resource))
    (list graph entity)))
