(in-package :ter)

(defun find-port-er (graph)
  (shinra:find-vertex graph 'port-er))

(defun get-port-er (graph &key code)
  (car (shinra:find-vertex graph 'port-er :slot 'code :value code)))

(defun tx-make-port-er (graph)
  (shinra:tx-make-vertex graph 'port-er '()))

(defun %add-port-er (graph from)
  (let ((port (tx-make-port-er graph)))
    (shinra:tx-make-edge graph 'edge-ter from port :have)
    port))

(defgeneric add-port-er (graph from)
  (:method (graph (from column-instance)) (%add-port-er graph from)))
