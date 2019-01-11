(in-package :ter)

(defun find-port (graph)
  ;; TODO: rename to find-port-ter
  (shinra:find-vertex graph 'port-ter))

(defun get-port (graph &key %id code)
  (cond (%id (shinra:get-vertex-at graph 'port-ter :%id %id))
        (code (car (shinra:find-vertex graph 'port-ter :slot 'code :value code)))))

(defun tx-make-port (graph)
  (shinra:tx-make-vertex graph 'port-ter '()))

(defun %add-port (graph from)
  (let ((port (tx-make-port graph)))
    (shinra:tx-make-edge graph 'edge-ter from port :have-to)
    port))

(defgeneric add-port (graph from)
  (:method (graph (from resource))            (%add-port graph from))
  (:method (graph (from event))               (%add-port graph from))
  (:method (graph (from comparative))         (%add-port graph from))
  (:method (graph (from correspondence))      (%add-port graph from))
  (:method (graph (from recursion))           (%add-port graph from))
  (:method (graph (from recursion))           (%add-port graph from))
  (:method (graph (from identifier-instance)) (%add-port graph from)))


(defun find-identifier-ports (graph identifer-instance)
  (shinra:find-r-vertex graph 'edge-ter
                        :from identifer-instance
                        :edge-type :have-to
                        :vertex-class 'port-ter))
