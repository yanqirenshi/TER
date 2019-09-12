(in-package :ter.api.controller)

(defun environments ()
  (let ((graph ter.db:*graph*))
    (list :|systems| (ter::find-systems graph)
          :schemas   (ter::find-schema  graph)
          :er `(:schema (:active ,(ter::config :er :schema :active))))))

(defun set-active-schema (schema)
  (setf (ter::config :er :schema :active) (ter::code schema))
  (environments))

(defun save-ter-camera-look-at (campus modeler code x y &key (graph ter.db:*graph*))
  (let ((camera (ter:get-ter-camera graph :campus campus :modeler modeler :code code)))
    (ter:tx-update-camera-look-at graph camera :x x :y y)))

(defun save-ter-camera-magnification
    (campus modeler code magnification &key (graph ter.db:*graph*))
  (let ((camera (ter:get-ter-camera graph :campus campus :modeler modeler :code code)))
    (ter:tx-update-camera-magnification graph camera magnification)))

;;;;;
;;;;; Pages
;;;;;
(defun pages-basic (graph modeler)
  (declare (ignore modeler))
  (list :|systems|  (ter::find-systems graph)
        :|schemas|  (ter::find-schema  graph)
        :|campuses| (ter::find-campus  graph)))
