(in-package :ter)

(defun tx-add-subset-core (graph entity entity-subset)
  (tx-make-relationship-rsc2evt-to graph entity entity-subset))

(defgeneric tx-add-subset (graph entity &key code name description)
  (:method (graph (entity resource) &key code name (description ""))
    (let ((entity-subset (list :code code
                               :name name
                               :description description)))
      (tx-add-subset-core graph entity entity-subset)))
  (:method (graph (entity event) &key code name (description ""))
    (let ((entity-subset (list :code code
                               :name name
                               :description description)))
      (tx-add-subset-core graph entity entity-subset))))
