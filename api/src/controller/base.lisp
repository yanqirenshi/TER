(in-package :ter.api.controller)

;;;;;
;;;;; get-schema-by-modeler
;;;;;
(defun get-schema-by-modeler.loop-schemas (graph schema-id schemas)
  (when-let ((schema (car schemas)))
    (if (= schema-id (up:%id schema))
        schema
        (get-schema-by-modeler.loop-schemas graph schema-id (cdr schemas)))))

(defun get-schema-by-modeler.loop-systems (graph schema-id systems)
  (when-let ((system (car systems)))
    (let ((schemas (ter:find-schema graph :system system)))
      (or (get-schema-by-modeler.loop-schemas graph schema-id schemas)
          (get-schema-by-modeler.loop-systems graph schema-id (cdr systems))))))

(defun get-schema-by-modeler (graph modeler &key schema-id)
  (assert graph)
  (when (and modeler schema-id)
    (get-schema-by-modeler.loop-systems graph schema-id (ter:find-systems graph :modeler modeler))))


;;;;;
;;;;; get-camera-by-schema
;;;;;
(defun get-camera-by-schema.loop-cameras (graph camera-id cameras)
  (when-let ((camera (car cameras)))
    (if (= camera-id (up:%id camera))
        camera
        (get-camera-by-schema.loop-cameras graph camera-id (cdr cameras)))))

(defun get-camera-by-schema (graph schema &key camera-id)
  (assert graph)
  (when (and schema camera-id)
    (get-camera-by-schema.loop-cameras graph
                                       camera-id
                                       (ter:find-camera graph :schema schema))))


;;;;;
;;;;; get-camera-by-schema
;;;;;
(defun get-table-by-schema.loop-tables (graph table-id tables)
  (when-let ((table (car tables)))
    (if (= table-id (up:%id table))
        table
        (get-table-by-schema.loop-tables graph table-id (cdr tables)))))

(defun get-table-by-schema (schema &key table-id)
  (assert schema)
  (let ((graph (ter::get-schema-graph schema)))
    (assert graph)
    (when (and schema table-id)
      (get-table-by-schema.loop-tables graph
                                       table-id
                                       (ter:find-table graph :schema schema)))))


;;;;;
;;;;; get-column-instance-by-table
;;;;;
(defun get-column-instance-by-table.loop-columns (graph column-id columns)
  (when-let ((column (car columns)))
    (if (= column-id (up:%id column))
        column
        (get-column-instance-by-table.loop-columns graph column-id (cdr columns)))))

(defun get-column-instance-by-table (schema table &key column-id)
  (assert schema)
  (let ((graph (ter::get-schema-graph schema)))
    (assert graph)
    (when (and table column-id)
      (get-column-instance-by-table.loop-columns graph
                                        column-id
                                        (ter::find-r-table_column-instance graph :table table)))))
