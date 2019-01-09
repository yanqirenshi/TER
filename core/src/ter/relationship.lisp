(in-package :ter)

(defgeneric tx-make-relationship (graph from to)

  (:method (graph (from resource) (to resource))
    (tx-make-relationship-rsc2rsc-th graph from to))

  (:method (graph (from resource) (to event))
    (tx-make-relationship-rsc2evt-to graph from to))

  (:method (graph (from event) (to event))
    ;;(tx-make-relationship-evt2evt-to graph from to)
    (error "building now..."))

  (:method (graph from to)
    (error "Bad combination. from=~a, to=~a" from to)))


;;;;;
;;;;; TODO: これもついかしたほうがよさそう。
;;;;;
(defgeneric tx-add-subset (graph entity)
  (:method (graph (entity resource))
    (list graph entity)))

(defgeneric tx-add-recursion (graph entity)
  (:method (graph (entity resource))
    (list graph entity)))

(defgeneric tx-add-detail (graph entity)
  (:method (graph (entity resource))
    (list graph entity))
  (:method (graph (entity event))
    (list graph entity)))
