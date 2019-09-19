(in-package :ter.api.controller)

(defun environments ()
  (let* ((graph ter.db:*graph*)
         (systems (ter::find-systems graph)))
    (list :|systems| (mapcar #'(lambda (d)
                                 (system2system graph d))
                             systems)
          :|campuses| (reduce #'(lambda (a system)
                                  (nconc a
                                         (ter:find-campus graph :system system)))
                              systems :initial-value nil)
          :|schemas| (reduce #'(lambda (a system)
                                  (nconc a
                                         (ter:find-schema graph :system system)))
                              systems :initial-value nil)
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
  (let ((camera (ter::get-to-cameras graph campus :modeler modeler :code code)))
    (ter:tx-update-camera-look-at graph camera :x x :y y)))

(defun save-ter-camera-magnification
    (campus modeler code magnification &key (graph ter.db:*graph*))
  (let ((camera (ter::get-to-cameras  graph campus :modeler modeler :code code)))
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
