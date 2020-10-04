(in-package :ter)


(defgeneric column-instance-port (graph column-instance type &key ensure)
  (:method (graph (column-instance column-instance) type &key (ensure t))
    (let ((ports (shinra:find-r-vertex graph 'edge-er
                                       :from column-instance
                                       :vertex-class (port-type2class type)
                                       :edge-type :have)))
      (when (< 1 (length ports)) (warn "port count over 2"))
      (or (first ports)
          (when ensure
            (add-port-er graph type column-instance))))))
