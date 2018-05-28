(in-package :ter)

(defun find-port (graph)
  (shinra:find-vertex graph 'port))

(defun get-port (graph &key code)
  (car (shinra:find-vertex graph 'port :slot 'code :value code)))

(defun tx-make-port (graph)
  (shinra:tx-make-vertex graph 'port '()))
