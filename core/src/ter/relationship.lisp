(in-package :ter)

(defgeneric tx-make-relationship (graph from to &key type)

  (:method (graph (from resource) (to resource)  &key type)
    (declare (ignore type))
    (tx-make-relationship-rsc2rsc-th graph from to))

  (:method (graph (from resource) (to event)  &key type)
    (declare (ignore type))
    (tx-make-relationship-rsc2evt-to graph from to))

  (:method (graph (from event) (to event)  &key type)
    (cond ((eq :hdr-dtl type)
           (tx-make-relationship-rsc2evt-to graph from to))
          ((null type)
           (error "Not Supported yet. Please wait build."))
          (t (error "Bad type. type=~S" type))))

  (:method (graph from to  &key type)
    (error "Bad combination. from=~a, to=~a, type=~a" from to type)))


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
