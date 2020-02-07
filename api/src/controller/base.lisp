(in-package :ter.api.controller)

(defun assert-authority (graph target modeler &rest authorities)
  (assert (ter::can-use-system-p graph target modeler authorities)))

(defun assert-force (graph modeler &rest forces)
  (assert (ter::have-force-p graph modeler forces)))


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
;;;;; get-table-by-schema
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


;;;;;
;;;;; get-campus-by-modeler
;;;;;
(defun get-campus-by-modeler.loop-campuses (graph campus-id campuses)
  (when-let ((campus (car campuses)))
    (if (= campus-id (up:%id campus))
        campus
        (get-campus-by-modeler.loop-campuses graph campus-id (cdr campuses)))))

(defun get-campus-by-modeler.loop-systems (graph campus-id systems)
  (when-let ((system (car systems)))
    (let ((campuses (ter:find-campus graph :system system)))
      (or (get-campus-by-modeler.loop-campuses graph campus-id campuses)
          (get-campus-by-modeler.loop-systems  graph campus-id (cdr systems))))))

(defun get-campus-by-modeler (graph modeler &key campus-id)
  (assert graph)
  (when (and modeler campus-id)
    (let ((systems (ter:find-systems graph :modeler modeler)))
      (get-campus-by-modeler.loop-systems graph campus-id systems))))


;;;;;
;;;;; get-campus-by-system-and-modeler
;;;;;
(defun get-campus-by-system-and-modeler (graph system modeler &key campus-id)
  (let ((campuse (get-campus-by-modeler graph modeler :campus-id campus-id)))
    (when (ter::get-r-system2campus graph system campuse)
      campuse)))


;;;;;
;;;;; get-camera-by-campus
;;;;;
(defun get-camera-by-campus.loop-cameras (graph camera-id cameras)
  (when-let ((camera (car cameras)))
    (if (= camera-id (up:%id camera))
        camera
        (get-camera-by-campus.loop-cameras graph camera-id (cdr cameras)))))

(defun get-camera-by-campus (graph campus &key camera-id)
  (assert graph)
  (when (and campus camera-id)
    (get-camera-by-campus.loop-cameras graph
                                       camera-id
                                       (ter:find-camera graph :campus campus))))


;;;;;
;;;;; get-entity-by-campus
;;;;;
(defun get-entity-by-campus.loop-campuses (graph entity-id campuses)
  (when-let ((campus (car campuses)))
    (if (= entity-id (up:%id campus))
        campus
        (get-entity-by-campus.loop-campuses graph entity-id (cdr campuses)))))

(defun get-entity-by-campus (campus &key entity-id)
  (assert campus)
  (let ((graph (ter::get-campus-graph campus)))
    (assert graph)
    (when (and campus entity-id)
      (get-entity-by-campus.loop-campuses graph
                                          entity-id
                                          (ter:find-entities graph)))))
