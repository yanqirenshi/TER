(in-package :ter)

(defun find-entities (graph)
  (nconc (find-resource       graph)
         (find-event          graph)
         (find-correspondence graph)
         (find-comparative    graph)
         (find-recursion      graph)))


(defun get-entity (graph &key %id)
  (or (get-resource       graph :%id %id)
      (get-event          graph :%id %id)
      (get-correspondence graph :%id %id)
      (get-comparative    graph :%id %id)
      (get-recursion      graph :%id %id)))
