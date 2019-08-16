(in-package :ter)

(defun tx-make-relationship-attr2attr-instance (graph attr-instance attr)
  (shinra:tx-make-edge graph 'edge-ter attr-instance attr :subset-of))
