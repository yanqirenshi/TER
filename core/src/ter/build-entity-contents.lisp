(in-package :ter)

;;;;;
;;;;; column
;;;;;
(defun get-entity-column-at-code (graph entity column-class code)
  (find-if #'(lambda (d) (string= code (code d)))
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

(defgeneric tx-add-identifier (graph entity identifier)
  (:method (graph (entity entity) (identifier identifier-instance))
    (assert-not-exist-entity-identifier graph entity :code (code identifier))
    (values identifier
            entity
            (shinra:tx-make-edge graph 'edge-ter entity identifier :have-to)))

  (:method (graph (entity entity) (params list))
    (let ((code (getf params :code))
          (name (getf params :name))
          (data-type (getf params :data-type)))
      (assert-not-exist-entity-identifier graph entity :code code)
      (tx-add-identifier graph entity
                         (tx-make-identifier-instance graph code name data-type)))))


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
            (shinra:tx-make-edge graph 'edge-ter entity attribute :have-to)))

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
