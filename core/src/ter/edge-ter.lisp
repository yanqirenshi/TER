(in-package :ter)

(defun find-edge-ter (graph)
  (gethash :edge-ter-root (up::root-objects graph)))

(defun find-edge-ter-port2port (graph)
  (remove-if #'(lambda (d)
                 (not (and (eq 'port-ter (shinra:from-class d))
                           (eq 'port-ter (shinra:to-class d)))))
          (find-edge-ter graph)))

(defun get-from-vertex (graph edge)
  (shinra:get-vertex-at graph (shinra:from-class edge)
                        :%id (shinra:from-id edge)))

(defun get-to-vertex (graph edge)
  (shinra:get-vertex-at graph (shinra:to-class edge)
                        :%id (shinra:to-id edge)))


;; fix direction
;; (let* ((campus (ter:get-campus ter.db:*graph* :code :rbp))
;;        (graph (ter::get-campus-graph campus)))
;;   (mapcar #'(lambda (edge)
;;               (setf (direction (get-from-vertex graph edge)) :out)
;;               (setf (direction (get-to-vertex graph edge)) :in))
;;           (find-edge-ter-port2port graph)))
