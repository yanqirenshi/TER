(in-package :ter)

(defun find-port (graph)
  ;; TODO: rename to find-port-ter
  (shinra:find-vertex graph 'port-ter))

(defun get-port (graph &key %id code)
  (warn "これは非推奨オペレータです。 get-port-ter を利用してください。")
  (cond (%id (shinra:get-vertex-at graph 'port-ter :%id %id))
        (code (car (shinra:find-vertex graph 'port-ter :slot 'code :value code)))))

(defun get-port-ter (graph &key %id code)
  (cond (%id (shinra:get-vertex-at graph 'port-ter :%id %id))
        (code (car (shinra:find-vertex graph 'port-ter :slot 'code :value code)))))


(defun tx-make-port (graph direction)
  (shinra:tx-make-vertex graph 'port-ter
                         `((direction ,direction))))

(defun %add-port (graph from direction)
  (let ((port (tx-make-port graph direction)))
    (shinra:tx-make-edge graph 'edge-ter from port :have-to)
    port))

(defgeneric add-port (graph from direction)
  (:method (graph (from resource)            direction) (%add-port graph from direction))
  (:method (graph (from event)               direction) (%add-port graph from direction))
  (:method (graph (from comparative)         direction) (%add-port graph from direction))
  (:method (graph (from correspondence)      direction) (%add-port graph from direction))
  (:method (graph (from recursion)           direction) (%add-port graph from direction))
  (:method (graph (from recursion)           direction) (%add-port graph from direction))
  (:method (graph (from identifier-instance) direction) (%add-port graph from direction)))

(defun find-identifier-ports (graph identifer-instance)
  (shinra:find-r-vertex graph 'edge-ter
                        :from identifer-instance
                        :edge-type :have-to
                        :vertex-class 'port-ter))
