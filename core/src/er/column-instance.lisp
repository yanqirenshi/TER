(in-package :ter)

(defun find-column-instance (graph)
  (find-vertex graph 'column-instance))

(defun get-column-instance (graph &key code)
  (car (find-vertex graph 'column-instance :slot 'code :value code)))

(defun tx-make-column-instance (graph code name data-type)
  (or (get-column-instance graph :code code)
      (tx-make-vertex graph
                      'column-instance
                      `((code ,code)
                        (name ,name)
                        (data-type ,data-type)))))
