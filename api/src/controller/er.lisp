(in-package :ter.api.controller)


;;;
;;; environments
;;;
(defun er-environment-at-modeler-schema (graph modeler schema)
  (assert (and graph modeler schema))
  (let ((system (ter:get-system graph :schema schema)))
    (list :|system|  system
          :|schema|  (schema2schema schema :graph graph :modeler modeler)
          :|schemas| (mapcar #'(lambda (schema)
                                 (schema2schema schema :graph graph :modeler modeler))
                             (ter::find-schema graph :system system)))))


;;;
;;; others
;;;
(defun save-er-camera-look-at (camera x y &key (graph ter.db:*graph*) modeler)
  (declare (ignore modeler))
  (ter:tx-update-camera-look-at graph camera :x x :y y))


(defun save-er-camera-magnification
    (camera magnification &key (graph ter.db:*graph*) modeler)
  (declare (ignore modeler))
  (ter:tx-update-camera-magnification graph camera magnification))

(defun throw-404 ()
  (caveman2:throw-code 404))

(defun finder-er-tables (graph)
  (ter:find-table graph))

(defun finder-er-columns (graph)
  (ter:find-column graph))

(defun finder-er-column-instances (graph)
  (ter:find-column-instance graph))

(defun finder-er-relashonships (graph)
  (ter:find-er-all-edges graph))

(defun find-er-all-nodes (graph)
  (nconc '()
         (finder-er-tables graph)
         (finder-er-columns graph)
         (finder-er-column-instances graph)))

(defun find-er-vertexes (schema)
  (let ((graph (ter::get-schema-graph schema)))
    (list :tables           (finder-er-tables graph)
          :columns          (finder-er-columns graph)
          :column_instances (finder-er-column-instances graph)
          :relashonships    (finder-er-relashonships graph)
          :ports            (ter::find-port-er graph))))

(defun find-er-edges (schema)
  (let ((graph (ter::get-schema-graph schema)))
    (list :edges (ter:find-er-all-edges graph))))

(defun find-er (schema)
  (append (find-er-vertexes schema)
          (find-er-edges schema)))


(defun save-er-position (schema table x y z)
  (assert (and schema table))
  (let ((graph (ter::get-schema-graph schema)))
    (ter::save-position graph table x y z)))

(defun save-er-size (schema table w h)
  (assert (and schema table))
  (let ((graph (ter::get-schema-graph schema)))
    (ter::save-size graph table w h)))


(defun save-config-at-default-schema (graph schema)
  (declare (ignore graph))
  schema)

(defun save-column-instance-logical-name (schema column-instance logical-name)
  (let ((schema-graph (ter::get-schema-graph schema)))
    (when (string/= (ter::logical-name column-instance) logical-name)
      (up:execute-transaction
       (up:tx-change-object-slots schema-graph
                                  (class-name (class-of column-instance))
                                  (up:%id column-instance)
                                  `((ter::logical-name ,logical-name)))))
    column-instance))

(defun save-column-instance-description (schema column-instance description)
  (let ((schema-graph (ter::get-schema-graph schema)))
    (up:execute-transaction
     (up:tx-change-object-slots schema-graph
                                (class-name (class-of column-instance))
                                (up:%id column-instance)
                                `((ter::description ,description))))))

(defun save-table-description (schema table description)
  (let ((schema-graph (ter::get-schema-graph schema)))
    (up:execute-transaction
     (up:tx-change-object-slots schema-graph
                                (class-name (class-of table))
                                (up:%id table)
                                `((ter::description ,description))))))
