(in-package :ter)

(defun find-schema (graph)
  (shinra:find-vertex graph 'schema))

(defun get-schema (graph &key code)
  (car (shinra:find-vertex graph 'schema
                           :slot 'code
                           :value (if (stringp code)
                                      (str2keyword code)
                                      code))))

(defgeneric tx-make-schema (graph code &key name description)
  (:method (graph code &key name description)
    (assert (not (get-schema graph)))
    (shinra:tx-make-vertex graph 'schema
                           `((code ,code)
                             (name ,name )
                             (description ,description)))))


;;;;;
;;;;; Schema graph
;;;;;
(defvar *er-schema-graphs* (make-hash-table))

(defgeneric get-schema-graph (schema)
  (:method ((schema-code symbol))
    (get-schema-graph (get-schema *graph* :code schema-code)))
  (:method ((schema schema))
    (let ((graph (gethash (code schema) *er-schema-graphs*)))
      (or graph
          (start-schema-graph schema)))))

(defgeneric start-schema-graph (schema)
  (:method ((schema schema))
    (let ((code (code schema))
          (store-dir (store-directory schema)))
      (when (gethash code *er-schema-graphs*)
        (error "この schema の graph は既に開始しています。"))
      (setf (gethash code *er-schema-graphs*)
            (shinra:make-banshou 'shinra:banshou store-dir)))))

(defgeneric stop-schema-graph (schema)
  (:method ((schema schema))
    (let* ((code (code schema))
           (graph (gethash code *er-schema-graphs*)))
      (when graph
        (shinra::stop graph)
        (remhash  code *er-schema-graphs*)))))

(defgeneric snapshot-schema-graph (schema)
  (:method ((schema schema))
    (let ((code (code schema)))
      (unless (gethash code *er-schema-graphs*)
        (error "この schema には graph が存在しません。"))
      (up:snapshot (gethash code *er-schema-graphs*)))))
