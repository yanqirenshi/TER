(in-package :ter)

(defun tx-create-system (graph modeler &key code name description)
  (declare (ignore modeler))
  (let ((system (tx-make-system graph code
                                :name name
                                :description description))
        (campus (tx-make-campus graph code :name name :description description))
        (schema (tx-make-schema graph code :name name :description description)))
    (tx-make-edge-system2campus graph system campus)
    (tx-make-edge-system2schema graph system schema)
    (tx-add-camera graph campus (tx-make-camera graph code))
    (tx-add-camera graph schema (tx-make-camera graph code))
    system))
