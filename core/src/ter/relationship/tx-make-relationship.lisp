(in-package :ter)

(defgeneric tx-make-relationship (graph from to &key type)

  ;;;;;
  ;;;;; resource --- resource
  ;;;;;
  (:method (graph (from resource) (to resource)  &key type)
    (declare (ignore type))
    (tx-make-relationship-rsc2rsc-th graph from to))

  ;;;;;
  ;;;;; resource --- event
  ;;;;;
  (:method (graph (from resource) (to event)  &key type)
    (declare (ignore type))
    (tx-make-relationship-rsc2evt-to graph from to))

  ;;;;;
  ;;;;; event --- event
  ;;;;;
  (:method (graph (from event) (to event) &key type)
    (cond ((eq :hdr-dtl type)
           (tx-make-relationship-rsc2evt-to graph from to))
          ((null type)
           (error "Not Supported yet. Please wait build."))
          (t (error "Bad type. type=~S" type))))

  ;;;;;
  ;;;;; identifier-instance --- identifier
  ;;;;;
  (:method (graph (from identifier-instance) (to identifier)  &key type)
    (declare (ignore type))
    (tx-make-relationship-id2id-instance graph from to))

  ;;;;;
  ;;;;; attribute-instance --- attribute
  ;;;;;
  (:method (graph (from attribute-instance) (to attribute)  &key type)
    (declare (ignore type))
    (tx-make-relationship-attr2attr-instance graph from to))

  ;;;;;
  ;;;;; port-ter --- port-ter
  ;;;;;
  (:method (graph (from port-ter) (to port-ter) &key type)
    (declare (ignore type))
    (shinra:tx-make-edge graph 'edge-ter from to :->))

  ;;;;;
  ;;;;; identifier-instance --- identifier-instance
  ;;;;;
  (:method (graph (from identifier-instance) (to identifier-instance) &key type)
    (declare (ignore type))
    (tx-make-relationship graph
                          (add-port graph from :out)
                          (add-port graph to   :in)))

  ;;;;;
  ;;;;; error
  ;;;;;
  (:method (graph from to  &key type)
    (error "Bad combination. from=~a, to=~a, type=~a" from to type)))
