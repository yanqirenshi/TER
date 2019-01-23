(in-package :ter.api.controller)

(defun environments ()
  (list :schemas (ter::find-schema ter.db:*graph*)
        :er `(:schema (:active ,(ter::config :er :schema :active)))))

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
