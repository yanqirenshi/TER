(in-package :ter.api.controller)

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

(defun find-er (schema)
  (let ((graph (ter::get-schema-graph schema)))
    (list :tables           (finder-er-tables graph)
          :columns          (finder-er-columns graph)
          :column_instances (finder-er-column-instances graph)
          :relashonships    (finder-er-relashonships graph)
          :ports            (ter::find-port-er graph)
          :edges            (ter:find-er-all-edges graph))))

(defun save-er-position (schema code position)
  (let* ((graph (ter::get-schema-graph schema))
         (table (ter::get-table graph :code code)))
    (unless table (caveman2:throw-code 404))
    (ter::save-position graph table position)))
