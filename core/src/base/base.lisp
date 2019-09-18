(in-package :ter)

(defun make-camera-code (code type)
  (alexandria:make-keyword
   (string-upcase
    (concatenate 'string (symbol-name code) "-" type))))

(defun tx-create-system (graph modeler &key code name description)
  (let ((system (tx-make-system graph code
                                :name name
                                :description description))
        (campus (tx-make-campus graph code :name name :description description))
        (schema (tx-make-schema graph code :name name :description description))
        (camera-campus (tx-make-camera graph (make-camera-code code "campus")))
        (camera-schema (tx-make-camera graph (make-camera-code code "schema"))))
    (tx-make-edge-system2campus graph system campus)
    (tx-make-edge-system2schema graph system schema)
    (tx-add-camera graph modeler camera-campus)
    (tx-add-camera graph modeler camera-schema)
    (tx-add-camera graph campus camera-campus)
    (tx-add-camera graph schema camera-schema)
    system))
