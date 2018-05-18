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
  (make-code (symbol-name (code entity)) "."  (make-attribute-code name data-type)))


;;;;;
;;;;; Import
;;;;;
(defun tx-import-attribute (graph data)
  (let* ((name (getf data :name))
         (limit (getf data :limit))
         (data-type (concatenate 'string
                                 (getf data :data-type)
                                 (if (not limit) "" (format nil "(~a)" limit))))
         (code (make-attribute-code name data-type)))
    (tx-make-attribute graph code name data-type)))

(defun tx-import-attribute-entity (graph entity data)
  (let* ((name (getf data :name))
         (limit (getf data :limit))
         (data-type (concatenate 'string
                                 (getf data :data-type)
                                 (if (not limit) "" (format nil "(~a)" limit))))
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

(defun tx-import-entity (graph plist)
  (let ((entity (tx-import-make-entity graph plist))
        (attributes-data (find-attribute-plists plist)))
    (tx-import-attributes graph entity attributes-data)
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
