(in-package :ter)

(defgeneric tx-make-relationship (graph from to &key type)

  (:method (graph (from resource) (to resource) &key (type :comparative))
    (cond ((eq :comparative type) (tx-make-relationship-rsc2rsc-th  graph from to))
          ((eq :recursion   type) (tx-make-relationship-rsc2rsc-rec graph from to))
          ((eq :detail      type) (tx-make-relationship-rsc2rsc-dtl graph from to))
          (t (error "bad type. type=~a" type))))

  (:method (graph (from resource) (to event) &key type)
    (declare (ignore type))
    (tx-make-relationship-rsc2evt-to graph from to))

  (:method (graph (from event) (to event) &key type)
    (declare (ignore type))
    (tx-make-relationship-evt2evt-to graph from to))

  (:method (graph from to &key type)
    (declare (ignore type))
    (error "Bad combination. from=~a, to=~a" from to)))
