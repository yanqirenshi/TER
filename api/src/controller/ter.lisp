(in-package :ter.api.controller)

(defun find-ter-all-nodes (graph)
  (nconc '()
         (ter:find-resource graph)
         (ter:find-event graph)
         (ter:find-correspondence graph)
         (ter:find-comparative graph)
         (ter:find-recursion graph)
         (ter:find-attribute graph)
         (ter:find-attribute-instance graph)
         (ter:find-identifier graph)
         (ter:find-identifier-instance graph)))

(defun find-ter ()
  (let ((graph ter.db:*graph*))
    (list :nodes (find-ter-all-nodes graph)
          :edges (ter:find-ter-all-edges graph))))

;;;;;
;;;;; new
;;;;;
(defun get-campus-graph (campus)
  (or (ter::get-campus-graph campus)
      (error "????????")))

(defun find-entity (campus)
  (let ((graph (ter::get-campus-graph campus)))
    (nconc (shinra:find-vertex graph 'resource)
           (shinra:find-vertex graph 'comparative)
           (shinra:find-vertex graph 'event)
           (shinra:find-vertex graph 'correspondence)
           (shinra:find-vertex graph 'recursion))))
