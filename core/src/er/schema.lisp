(in-package :ter)

(defun find-schema (graph)
  (shinra:find-vertex graph 'schema))

(defun get-schema (graph &key code)
  (car (shinra:find-vertex graph 'schema :slot 'code :value code)))

(defgeneric tx-make-schema (graph code &key name description)
  (:method (graph code &key name description)
    (assert (not (get-schema graph)))
    (shinra:tx-make-vertex graph 'schema
                           `((code ,code)
                             (name ,name )
                             (description ,description)))))

(defvar *er-schema-graphs* (make-hash-table))

(defgeneric start-schema-graph (schema)
  (:method ((schema schema))
    (let ((code (code schema))
          (store-dir (store-directory schema)))
      (when (gethash code *er-schema-graphs*)
        (error "xxx"))
      (setf (gethash code *er-schema-graphs*)
            (shinra:make-banshou 'shinra:banshou store-dir)))))

(defgeneric snapshot-schema-graph (schema)
  (:method ((schema schema))
    (let ((code (code schema)))
      (unless (gethash code *er-schema-graphs*)
        (error "xxx"))
      (up:snapshot (gethash code *er-schema-graphs*)))))
