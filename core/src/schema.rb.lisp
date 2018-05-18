(in-package :ter)

;;;;;
;;;;; get / find
;;;;;
(defun get-table-plist (plists)
  (when-let ((plist (car plists)))
    (if (eq :table-start (getf plist :type))
        plist
        (get-table-plist (cdr plists)))))

(defun find-attribute-plists (plists)
  (when-let ((plist (car plists)))
    (if (not (eq :attribute (getf plist :type)))
        (find-attribute-plists (cdr plists))
        (cons plist
              (find-attribute-plists (cdr plists))))))

(defun find-foreign-key-plists (plists)
  (when-let ((plist (car plists)))
    (if (not (getf plist :foreign-key))
        (find-foreign-key-plists (cdr plists))
        (cons plist
              (find-foreign-key-plists (cdr plists))))))

;;;;;
;;;;; Utility
;;;;;
(defun make-code (&rest strs)
  (alexandria:make-keyword (string-upcase (apply #'concatenate 'string strs))))

(defun make-entity-code (name)
  (make-code name))

(defun make-attribute-code (name data-type)
  (make-code name "@" data-type))

(defun make-attribute-entity-code (entity name data-type)
  (make-code (symbol-name (code entity)) "." name "@" data-type))

(defun make-data-type (data)
  (let ((limit (getf data :limit)))
    (concatenate 'string
                 (getf data :data-type)
                 (if (not limit) "" (format nil "(~a)" limit)))))


;;;;;
;;;;; Import
;;;;;
(defun tx-import-attribute (graph data)
  (let* ((name (getf data :name))
         (data-type (make-data-type data))
         (code (make-attribute-code name data-type)))
    (tx-make-attribute graph code name data-type)))

(defun tx-import-attribute-entity (graph entity data)
  (let* ((name (getf data :name))
         (data-type (make-data-type data))
         (code (make-attribute-entity-code entity name data-type)))
    (tx-make-attribute-entity graph code name data-type)))

(defun tx-import-attributes (graph entity attributes-data)
  (when-let ((data (car attributes-data)))
    (let* ((attribute (tx-import-attribute graph data))
           (attribute-entity (tx-import-attribute-entity graph entity data)))
      (tx-make-r-attribute_attribute-entity graph attribute attribute-entity)
      (tx-make-r-entity-attribute-entity graph entity attribute-entity)
      (cons attribute-entity
            (tx-import-attributes graph entity (cdr attributes-data))))))

(defun tx-import-make-entity (graph plist)
  (let* ((data (get-table-plist plist))
         (name (getf data :name)))
    (tx-make-entity graph
                    (make-entity-code name)
                    name)))

(defun xxx (graph from-attribute-entity to-attribute-entity)
  (print (list from-attribute-entity to-attribute-entity)))

(defun tx-import-foreign-key (graph from-entity fk)
  (let ((from-attr-entity-code (make-attribute-entity-code from-entity (getf fk :name) (make-data-type fk)))
        (to-entity (get-entity graph :code (make-entity-code (getf (getf fk :foreign-key) :references)))))
    (xxx graph
         (get-attribute-entity graph :code from-attr-entity-code)
         (get-id-attribute-entity graph to-entity))))

(defun tx-import-foreign-keys (graph entity plist)
  (dolist (fka (find-foreign-key-plists plist))
    (tx-import-foreign-key graph entity fka)))

(defun get-id-attribute-entity (graph entity)
  (find-if #'(lambda (attr)
               (eq (code attr)
                   (make-attribute-entity-code entity "id" "integer")))
           (shinra:find-r-vertex graph 'shinra:ra
                                 :from entity)))

(defun tx-import-entity (graph plist)
  (let ((entity (tx-import-make-entity graph plist))
        (attributes-data (cons '(:type :attribute :alias "t" :name "id" :data-type "integer")
                               (find-attribute-plists plist))))
    (tx-import-attributes graph entity attributes-data)
    (tx-import-foreign-keys graph entity plist)
    entity))

;;;;;
;;;;; Main
;;;;;
(defun %import-schema.rb (graph plists)
  (when-let ((plist (car plists)))
    (cons (up:execute-transaction (tx-import-entity graph plist))
          (%import-schema.rb graph (cdr plists)))))

(defun import-schema.rb (graph pathname)
  (%import-schema.rb graph (ter.parser:parse-schema.rb pathname)))
