(in-package :ter)

(defun tx-make-relationship-id2id-instance (graph id-instance id)
  (shinra:tx-make-edge graph 'edge-ter id-instance id :subset-of))
