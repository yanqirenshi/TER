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

(defun find-entities (campus)
  (let ((graph (ter::get-campus-graph campus)))
    (nconc (shinra:find-vertex graph 'resource)
           (shinra:find-vertex graph 'comparative)
           (shinra:find-vertex graph 'event)
           (shinra:find-vertex graph 'correspondence)
           (shinra:find-vertex graph 'recursion))))

(defun find-identifier-instances (campus)
  (let ((graph (ter::get-campus-graph campus)))
    (shinra:find-vertex graph 'ter::identifier-instance)))


(defun find-identifier-attributes (campus)
  (let ((graph (ter::get-campus-graph campus)))
    (shinra:find-vertex graph 'ter::attribute-instance)))

(defun %find-edge-ters (graph entities)
  (when-let ((entity (car entities)))
    (nconc (shinra:find-r-edge graph 'ter::edge-ter :from entity)
           (%find-edge-ters graph (cdr entities)))))

(defun find-edge-ters (campus)
  (let ((graph (ter::get-campus-graph campus))
        (entities (find-entities campus)))
    (%find-edge-ters graph entities)))
