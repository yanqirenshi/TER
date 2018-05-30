(in-package :ter)

(defun find-camera (graph)
  (shinra:find-vertex graph 'camera))

(defun get-camera (graph &key code)
  (car (shinra:find-vertex graph 'camera :slot 'code :value code)))

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
