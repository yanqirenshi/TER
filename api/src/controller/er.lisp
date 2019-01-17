(in-package :ter.api.controller)

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
    (list :edges            (ter:find-er-all-edges graph))))

(defun find-er (schema)
  (append (find-er-vertexes schema)
          (find-er-edges schema)))


(defun save-er-position (schema code position)
  (let* ((graph (ter::get-schema-graph schema))
         (table (ter::get-table graph :code code)))
    (unless table (caveman2:throw-code 404))
    (ter::save-position graph table position)))

(defun save-er-size (schema code w h)
  (let* ((graph (ter::get-schema-graph schema))
         (table (ter::get-table graph :code code)))
    (unless table (caveman2:throw-code 404))
    (ter::save-size graph table w h)))


(defun save-config-at-default-schema (graph schema)
  (declare (ignore graph))
  schema)

(defun save-column-instance-logical-name (schema table-code colun-code logical-name)
  (let* ((schema-graph (ter::get-schema-graph schema))
         (table (ter::get-table schema-graph :code table-code)))
    (unless table (throw-404))
    (let ((column-instance (ter::table-column-instance schema-graph table-code colun-code)))
      (unless column-instance (throw-404))
      (when (string/= (ter::logical-name column-instance) logical-name)
        (up:execute-transaction
         (up:tx-change-object-slots schema-graph
                                    (class-name (class-of column-instance))
                                    (up:%id column-instance)
                                    `((ter::logical-name ,logical-name)))))
      column-instance)))

(defun save-column-instance-description (schema %id description)
  (let* ((schema-graph (ter::get-schema-graph schema))
         (column-instance (ter::get-column-instance schema-graph :%id %id)))
    (up:execute-transaction
     (up:tx-change-object-slots schema-graph
                                (class-name (class-of column-instance))
                                (up:%id column-instance)
                                `((ter::description ,description))))))

(defun save-table-description (schema table-code description)
  (let* ((schema-graph (ter::get-schema-graph schema))
         (table (ter::get-table schema-graph :code table-code)))
    (up:execute-transaction
     (up:tx-change-object-slots schema-graph
                                (class-name (class-of table))
                                (up:%id table)
                                `((ter::description ,description))))))
