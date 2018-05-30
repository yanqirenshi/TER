(in-package :ter.api.controller)

(defun find-graph (graph)
  (list :nodes ()
        :edges (ter:find-mapping-all-edges graph)))
