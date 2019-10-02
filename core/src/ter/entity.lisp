(in-package :ter)

(defun find-entities (graph)
  (nconc (find-resource       graph)
         (find-event          graph)
         (find-correspondence graph)
         (find-comparative    graph)
         (find-recursion      graph)))
