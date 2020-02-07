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

;;;;;;;;
;;;;;;;;  New
;;;;;;;;
(defun get-campus-graph (campus)
  (or (ter::get-campus-graph campus)
      (error "????????")))


;;;
;;; environment
;;;
(defun ter-environment-at-modeler-system-campus (graph modeler campus)
  (assert graph)
  (when (and modeler campus)
    (let ((system (ter:get-system graph :campus campus)))
      (list :|system|   system
            :|campus|   (campus2campus campus :graph graph :modeler modeler)
            :|campuses| (mapcar #'(lambda (campus)
                                    (campus2campus campus :graph graph :modeler modeler))
                                (ter::find-campus graph :system system))))))


;;;
;;; entity
;;;
(defun find-entities (campus)
  (let ((graph (ter::get-campus-graph campus)))
    (nconc (shinra:find-vertex graph 'resource)
           (shinra:find-vertex graph 'resource-subset)
           (shinra:find-vertex graph 'comparative)
           (shinra:find-vertex graph 'event)
           (shinra:find-vertex graph 'event-subset)
           (shinra:find-vertex graph 'correspondence)
           (shinra:find-vertex graph 'recursion))))

(defun get-entity (campus &key %id)
  (let ((graph (ter::get-campus-graph campus)))
    (or (shinra:get-vertex-at graph 'resource        :%id %id)
        (shinra:get-vertex-at graph 'resource-subset :%id %id)
        (shinra:get-vertex-at graph 'comparative     :%id %id)
        (shinra:get-vertex-at graph 'event           :%id %id)
        (shinra:get-vertex-at graph 'event-subset    :%id %id)
        (shinra:get-vertex-at graph 'correspondence  :%id %id)
        (shinra:get-vertex-at graph 'recursion       :%id %id))))


(defun save-entity-position (campus entity x y z)
  (let ((graph (ter::get-campus-graph campus)))
    (let ((new-point (make-instance 'ter::point :x x :y y :z z)))
      (up:execute-transaction
       (up:tx-change-object-slots graph (class-name (class-of entity))
                                  (up:%id entity)
                                  `((ter::location ,new-point)))))))

(defun find-entities-ports (campus)
  (let ((graph (ter::get-campus-graph campus)))
    (shinra:find-vertex graph 'ter::port-ter)))


;;;
;;; identifier-instances
;;;
(defun find-identifier-instances (campus)
  (let ((graph (ter::get-campus-graph campus)))
    (shinra:find-vertex graph 'ter::identifier-instance)))


(defun find-attributes-instances (campus)
  (let ((graph (ter::get-campus-graph campus)))
    (shinra:find-vertex graph 'ter::attribute-instance)))

(defun find-edge-ters-entities (graph entities)
  (when-let ((entity (car entities)))
    (nconc (shinra:find-r-edge graph 'ter::edge-ter :from entity)
           (find-edge-ters-entities graph (cdr entities)))))

(defun find-edge-ters-identifiers (graph identifiers)
  (when-let ((identifier (car identifiers)))
    (nconc (shinra:find-r-edge graph 'ter::edge-ter :from identifier)
           (find-edge-ters-identifiers graph (cdr identifiers)))))

(defun find-all-edges (graph objects)
  (when-let ((object (car objects)))
    (nconc (shinra:find-r-edge graph 'ter::edge-ter :from object)
           (find-all-edges graph (cdr objects)))))

(defun find-edge-ters (campus)
  (let ((graph      (ter::get-campus-graph campus))
        (entities   (find-entities campus))
        (identifers (find-identifier-instances campus))
        (ports      (find-entities-ports campus)))
    (nconc (find-all-edges graph entities)
           (find-all-edges graph identifers)
           (find-all-edges graph ports))))


;;;
;;; save-port-ter-location
;;;
(defun save-port-ter-location (campus port-id new-location)
  (let* ((graph (ter::get-campus-graph campus))
         (port (ter::get-port-ter graph :%id port-id)))
    (unless port (caveman2:throw-code 404))
    (up:execute-transaction
     (up:tx-change-object-slots graph (class-name (class-of port))
                                (up:%id port)
                                `((ter::location ,new-location))))))


;;;
;;; create-entity
;;;
(defun create-entity (campus &key type code name description)
  (let ((graph (ter::get-campus-graph campus))
        (type-keyword (alexandria:make-keyword (string-upcase type))))
    (assert graph)
    (up:execute-transaction
     (ter::tx-build-identifier graph type-keyword code name :description description))))


(defun snapshot-campus-graph (campus)
  (let ((graph (ter::get-campus-graph campus)))
    (assert graph)
    (up:snapshot graph)))


;;;;;
;;;;; System
;;;;;
(defun create-system (graph modeler &key code name description)
  (up:execute-transaction
   (ter:tx-create-system graph modeler
                         :code code
                         :name name
                         :description description)))
