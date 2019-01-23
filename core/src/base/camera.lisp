(in-package :ter)

(defun find-camera (graph)
  (shinra:find-vertex graph 'camera))

(defun get-camera (graph &key code %id)
  (let ((camera-class 'camera))
    (cond (code (car (shinra:find-vertex graph camera-class :slot 'code :value code)))
          (%id  (shinra:get-vertex-at graph camera-class :%id %id)))))

(defgeneric tx-make-camera (graph code &key name description magnification look-at)
  (:method (graph code &key name description
                    (magnification 1)
                    (look-at '(:x 0 :y 0 :z 0)) )
    (assert (not (get-camera graph)))
    (or (get-camera graph :code code)
        (shinra:tx-make-vertex graph 'camera
                               `((code ,code)
                                 (name ,name )
                                 (description ,description)
                                 (magnification ,magnification)
                                 (look-at ,look-at))))))


(defun tx-update-camera-look-at (graph camera &key x y z)
  (let ((look-at (list :x (or x (getf (look-at camera) :x))
                       :y (or y (getf (look-at camera) :y))
                       :z (or z (getf (look-at camera) :z)))))
    (up:tx-change-object-slots graph 'camera (up:%id camera) `((look-at ,look-at)))))

(defun tx-update-camera-magnification (graph camera magnification)
  (up:tx-change-object-slots graph 'camera
                             (up:%id camera)
                             `((magnification ,magnification))))
