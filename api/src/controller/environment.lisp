(in-package :ter.api.controller)

(defun environments (graph modeler)
  (let* ((graph ter.db:*graph*)
         (systems (ter::find-systems graph)))
    (list :|systems| (mapcar #'(lambda (d)
                                 (system2system graph d))
                             systems)
          :|modeler| (modeler2modeler modeler)
          :|active| (list :|system| (ter::config :active :system)
                          :|ter|    (list :|campus| :null)
                          :|er|     (list :|schema| :null)))))

(defun set-active-schema (schema)
  (setf (ter::config :er :schema :active) (ter::code schema))
  (environments))

(defun set-active-system (system)
  (setf (ter::config :active :system) (up:%id system))
  (environments))


(defun save-ter-camera-look-at (campus modeler code x y &key (graph ter.db:*graph*))
  (let ((camera (ter:get-to-camera graph
                                   :obj campus
                                   :modeler modeler
                                   :code code)))
    (unless camera (caveman2:throw-code 404))
    (ter:tx-update-camera-look-at graph camera :x x :y y)))


(defun save-ter-camera-magnification
    (campus modeler code magnification &key (graph ter.db:*graph*))
  (let ((camera (ter:get-to-camera graph
                                   :obj campus
                                   :modeler modeler
                                   :code code)))
    (unless camera (caveman2:throw-code 404))
    (ter:tx-update-camera-magnification graph camera magnification)))

;;;;;
;;;;; Pages
;;;;;
(defun pages-basic (graph modeler)
  (declare (ignore modeler))
  (list :|systems|  (ter::find-systems graph)
        :|schemas|  (ter::find-schema  graph)
        :|campuses| (ter::find-campus  graph)))

(defun pages-system (graph system modeler)
  (list :|system|   system
        :|schemas|  (mapcar #'(lambda (schema)
                                (schema2schema schema :graph graph :modeler modeler))
                            (ter:find-schema graph :system system))
        :|campuses| (mapcar #'(lambda (campus)
                                (campus2campus campus :graph graph :modeler modeler))
                            (ter:find-campus graph :system system))))
