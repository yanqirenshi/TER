(in-package :ter)

(defun tx-add-subset-core (graph entity entity-subset)
  (tx-make-relationship-rsc2evt-to graph entity entity-subset))

(defgeneric tx-add-subset (graph entity &key code name description)
  ;;;;;
  ;;;;; resource or resource-subset --- resource-subset
  ;;;;;
  (:method (graph (entity resource) &key code name (description ""))
    (let ((entity-subset (tx-make-resource-subset graph code name :description description)))
      (tx-add-subset-core graph entity entity-subset)))

  ;;;;;
  ;;;;; event or event-subset --- event-subset
  ;;;;;
  (:method (graph (entity event) &key code name (description ""))
    (let ((entity-subset (tx-make-event-subset graph code name :description description)))
      (tx-add-subset-core graph entity entity-subset))))
