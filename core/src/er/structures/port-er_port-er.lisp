(in-package :ter)


(defun find-r-port-er-from-to-port-er-in (graph from)
  (shinra:find-r-edge graph 'edge-er
                      :from from
                      :edge-type :fk
                      :vertex-class 'port-er-in))


(defgeneric get-r-port-er-to-port-er (graph out in)
  (:method (graph (out port-er-out) (in port-er-in))
    (find-if #'(lambda (d)
                 (= (up:%id d) (up:%id in)))
             (shinra:find-r-vertex graph 'edge-er
                                   :from out
                                   :edge-type :fk
                                   :vertex-class 'port-er-in))))


(defgeneric tx-make-r-port-er (graph out in)
  (:method (graph (out port-er-out) (in port-er-in))
    (or (get-r-port-er-to-port-er graph out in)
        (tx-make-edge graph 'edge-er out in :fk))))
