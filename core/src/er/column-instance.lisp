(in-package :ter)

(defun find-column-instance (graph)
  (find-vertex graph 'column-instance))

(defun get-column-instance (graph &key code %id)
  (cond (code (car (find-vertex graph 'column-instance :slot 'code :value code)))
        (%id  (shinra:get-vertex-at graph 'column-instance :%id %id))))

(defun tx-make-column-instance (graph code name data-type &optional (column-type :attribute))
  (tx-make-vertex graph
                  'column-instance
                  `((code ,code)
                    (name ,name)
                    (data-type ,data-type)
                    (column-type ,column-type))))

(defmethod tx-update-column-instance (graph column-instance name data-type &optional (column-type :attribute))
  (up:tx-change-object-slots graph
                             (class-name (class-of column-instance))
                             (up:%id column-instance)
                             `((name ,name)
                               (physical-name ,name)
                               (data-type ,data-type)
                               (column-type ,column-type))))
