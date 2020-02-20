(in-package :ter)


;;;;;
;;;;; entity : attribute-instance
;;;;;
(defun get-entity-attribute-at-code (graph entity code)
  (get-entity-column-at-code graph entity 'attribute-instance code))


(defun assert-not-exist-entity-attribute (graph entity &key code)
  (when (get-entity-attribute-at-code graph entity code)
    (error "aledy exist relationship of entity to attribute")))


(defgeneric tx-add-attribute-instance (graph entity attribute)
  (:method (graph (entity entity) (attribute attribute-instance))
    (assert-not-exist-entity-attribute graph entity :code (code attribute))
    (values attribute
            entity
            (shinra:tx-make-edge graph 'edge-ter entity attribute :have-to-native)))

  (:method (graph (entity entity) (attribute attribute))
    (assert-not-exist-entity-attribute graph entity :code (code attribute))
    (tx-add-attribute-instance graph entity (list :code      (code attribute)
                                                  :name      (name attribute)
                                                  :data-type (data-type attribute))))

  (:method (graph (entity entity) (params list))
    (let ((code        (getf params :code))
          (name        (getf params :name))
          (data-type   (getf params :data-type))
          (description (getf params :description)))
      (assert-not-exist-entity-attribute graph entity :code code)
      (tx-add-attribute-instance graph entity
                                 (tx-make-attribute-instance graph code name data-type :description description)))))


;;;;;
;;;;; tx-add-attributes
;;;;;
(defgeneric tx-add-attributes (graph entity attr-data-list)
  (:method (graph (entity entity) (attr-data-list list))
    (dolist (attr-data attr-data-list)
      (let* ((code (getf attr-data :code))
             (attribute (or (get-attribute graph :code code)
                            (tx-make-attribute graph
                                               code
                                               (getf attr-data :name)
                                               (getf attr-data :data-type)))))
        (tx-add-attribute-instance graph entity attribute)))))


;; (let ((graph (get-campus-graph (get-campus ter.db:*graph* :code "GLPGS"))))
;;   (tx-add-attributes graph
;;                      (get-event graph :code :resource-estimate)
;;                      '((:code :amount             :name "数量"           :data-type :integer)
;;                        (:code :unit               :name "単位"           :data-type :string)
;;                        (:code :valid-period-start :name "有効期間(開始)" :data-type :timestamp)
;;                        (:code :valid-period-end   :name "有効期間(終了)" :data-type :timestamp)
;;                        (:code :description        :name "備考"           :data-type :text))))
