(in-package :ter)

;;;;;
;;;;; column
;;;;;
(defun get-entity-column-at-code (graph entity column-class code)
  (find-if #'(lambda (r)
               (let ((vertex (getf r :vertex)))
                 (string= code (code vertex))))
           (shinra:find-r graph 'edge-ter
                          :from entity
                          :vertex-class column-class
                          :edge-type :have-to)))

;;;;;
;;;;; identifier
;;;;;
(defun get-entity-identifier-at-code (graph entity code)
  (get-entity-column-at-code graph entity 'identifier-instance code))

(defun assert-not-exist-entity-identifier (graph entity &key code)
  (when (get-entity-identifier-at-code graph entity code)
    (error "aledy exist relationship of entity to identifier")))

(defun get-native-identifier (graph entity)
  (assert graph) (assert entity)
  (car (shinra:find-r-vertex graph
                             'edge-ter
                             :from entity
                             :edge-type :have-to-native
                             :vertex-class 'identifier-instance)))

(defun assert-not-exist-native-identifier (graph entity type)
  (when (eq :native type)
    (when (get-native-identifier graph entity)
      (error "Aledy have native identifier."))))

(defun get-identifier-edge-type (type)
  (cond ((eq :native    type) :have-to-native)
        ((eq :foreigner type) :have-to-foreigner)
        (t (error "Not supported yet. type=~S" type))))

(defgeneric assert-entity-identifier-type (entity type)
  (:method ((entity resource) type)
    (unless (eq :native type)
      (error "Invalid type. entity=~S, type=~S" entity type)))
  (:method ((entity event) type)
    (unless (or (eq :native type) (eq :foreigner type))
      (error "Invalid type. entity=~S, type=~S" entity type)))
  (:method ((entity correspondence) type)
    (unless (eq :foreigner type)
      (error "Invalid type. entity=~S, type=~S" entity type)))
  (:method ((entity recursion) type)
    (unless (eq :foreigner type)
      (error "Invalid type. entity=~S, type=~S" entity type)))
  (:method ((entity comparative) type)
    (unless (eq :foreigner type)
      (error "Invalid type. entity=~S, type=~S" entity type)))
  (:method (entity type)
    (error "Invalid entity. entity=~S, type=~S" entity type)))

(defgeneric tx-add-identifier (graph entity identifier &key type)
  (:method (graph (entity entity) (identifier identifier-instance) &key (type :native))
    (assert-entity-identifier-type entity type)
    (assert-not-exist-native-identifier graph entity type)
    (assert-not-exist-entity-identifier graph entity :code (code identifier))
    (let ((edge-type (get-identifier-edge-type type)))
      (values identifier
              entity
              (shinra:tx-make-edge graph 'edge-ter entity identifier edge-type))))

  (:method (graph (entity entity) (params list) &key (type :native))
    (let ((code (getf params :code))
          (name (getf params :name))
          (data-type (getf params :data-type)))
      (assert-not-exist-entity-identifier graph entity :code code)
      (tx-add-identifier graph
                         entity
                         (tx-make-identifier-instance graph code name data-type)
                         :type type))))


;;;;;
;;;;; attribute
;;;;;
(defun get-entity-attribute-at-code (graph entity code)
  (get-entity-column-at-code graph entity 'attribute-instance code))

(defun assert-not-exist-entity-attribute (graph entity &key code)
  (when (get-entity-attribute-at-code graph entity code)
    (error "aledy exist relationship of entity to attribute")))

(defgeneric tx-add-attribute (graph entity attribute)
  (:method (graph (entity entity) (attribute attribute-instance))
    (assert-not-exist-entity-attribute graph entity :code (code attribute))
    (values attribute
            entity
            (shinra:tx-make-edge graph 'edge-ter entity attribute :have-to-native)))

  (:method (graph (entity entity) (params list))
    (let ((code (getf params :code))
          (name (getf params :name))
          (data-type (getf params :data-type)))
      (assert-not-exist-entity-attribute graph entity :code code)
      (tx-add-attribute graph entity
                        (tx-make-attribute-instance graph code name data-type)))))


;;;;;
;;;;; port-ter
;;;;;
(defgeneric tx-add-port-ter (entity port-ter)
  (:method ((entity entity) (port-ter port-ter))
    (list entity port-ter)))
