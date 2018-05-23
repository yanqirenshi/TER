(in-package :ter)


;;;;;
;;;;; Common
;;;;;
(defun pool-key-ra (class)
  (alexandria:make-keyword (concatenate 'string (symbol-name class) "-ROOT")))

(defun find-all-edges (graph &key (class 'shinra:ra))
  (gethash (pool-key-ra class)
           (up::root-objects graph)))

(defmethod jojo:%to-json ((obj shinra:ra))
  (jojo:with-object
    (jojo:write-key-value "_id"        (slot-value obj 'up:%id))
    (jojo:write-key-value "from-id"    (slot-value obj 'shinra:from-id))
    (jojo:write-key-value "from-class" (slot-value obj 'shinra:from-class))
    (jojo:write-key-value "to-id"      (slot-value obj 'shinra:to-id))
    (jojo:write-key-value "to-class"   (slot-value obj 'shinra:to-class))
    (jojo:write-key-value "data_type"  (slot-value obj 'shinra:edge-type))
    (jojo:write-key-value "_class"     'shinra:ra)))


;;;;;
;;;;; attribute ⇒ attribute-entity
;;;;;
(defun find-r-attribute_attribute-entity (graph &key attribute)
  (when attribute
    (shinra:find-r-vertex graph 'shinra:ra
                          :from attribute
                          :vertex-class 'attribute-entity
                          :edge-type :instance-of)))

(defun get-r-attribute_attribute-entity (graph attribute attribute-entity)
  (find-if #'(lambda (r)
               (string= (code r) (code attribute-entity)))
           (find-r-attribute_attribute-entity graph :attribute attribute)))

(defun tx-make-r-attribute_attribute-entity (graph attribute attribute-entity)
  (or (get-r-attribute_attribute-entity graph attribute attribute-entity)
      (tx-make-edge graph 'shinra:ra attribute attribute-entity :instance-of)))


;;;;;
;;;;; entity ⇒ attribute-entity
;;;;;
(defun find-r-entity_attribute-entity (graph &key entity)
  (when entity
    (shinra:find-r-vertex graph 'shinra:ra
                          :from entity
                          :vertex-class 'attribute-entity
                          :edge-type :have)))

(defun get-r-entity_attribute-entity (graph entity attribute-entity)
  (find-if #'(lambda (r)
               (string= (code r) (code attribute-entity)))
           (find-r-entity_attribute-entity graph :entity entity)))

(defun tx-make-r-entity_attribute-entity (graph entity attribute-entity)
  (or (get-r-entity_attribute-entity graph entity attribute-entity)
      (tx-make-edge graph 'shinra:ra entity attribute-entity :have)))
