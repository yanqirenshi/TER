(in-package :ter)

;; (:schema (:default :schema-code1
;;           :schema-code1 (:camera (:position '(x y z)))
;;           :schema-code2 (:camera (:position '(x y z)))
;;           :schema-code3 (:camera (:position '(x y z)))))

(defgeneric tx-save-default-schema (graph config schema-code)
  (:method (graph (config config) schema-code)
    (let ((schema (copy-list (getf (contents config) :schema))))
      (setf (getf schema :default) schema-code)
      config)))
