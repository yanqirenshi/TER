(in-package :ter)

;; TODO: ここじゃない。。。
(defclass edge (shinra:ra) ())


(defgeneric have-camera-p (graph obj)
  (:method (graph (obj schema))
    (not (null (shinra:find-r-vertex graph 'edge :from obj :vertex-class 'camera :edge-type :have-to)))))

(defgeneric tx-add-camera (graph obj camera)
  (:method (graph (obj schema) (camera camera))
    (shinra:tx-make-edge graph 'edge obj camera :have-to)))



(defgeneric find-schema-camera (graph obj)
  (:method (graph (obj schema))
    (shinra:find-r-vertex graph 'edge
                          :from obj
                          :vertex-class 'camera
                          :edge-type :have-to)))
