(in-package :ter)

(defgeneric have-camera-p (graph obj)
  (:method (graph (obj schema))
    (not (null (shinra:find-r-vertex graph 'edge :from obj :vertex-class 'camera :edge-type :have-to)))))


(defun find-obj-camera (graph obj)
  (shinra:find-r graph 'edge
                 :from obj
                 :edge-type :have-to
                 :vertex-class 'camera))

(defun get-r-obj2camera (graph obj camera)
  (find-if #'(lambda (r)
               (let ((camera_tmp (getf r :vertex)))
                 (eq (code camera_tmp) (code camera))))
           (shinra:find-r graph 'edge :from obj
                                      :edge-type :have-to
                                      :vertex-class 'camera)))


(defun get-edge-obj2camera (graph system campus)
  (when-let ((r (get-r-obj2camera graph system campus)))
    (getf r :edge)))


(defun %tx-add-camera (graph obj camera)
  (or (get-edge-obj2camera graph obj camera)
      (shinra:tx-make-edge graph 'edge obj camera :have-to)))


(defgeneric tx-add-camera (graph obj camera)
  (:method (graph (obj schema) (camera camera))
    (%tx-add-camera graph obj camera))

  (:method (graph (obj campus) (camera camera))
    (%tx-add-camera graph obj camera))

  (:method (graph (obj modeler) (camera camera))
    (%tx-add-camera graph obj camera)))


(defun %find-to-cameras (graph from from-class r-list)
  (when-let ((r (car r-list)))
    (let* ((camera (getf r :vertex))
           (r (find-if #'(lambda (r)
                           (eq (up:%id (getf r :vertex))
                               (up:%id from)))
                       (shinra:find-r graph 'edge
                                      :to camera
                                      :vertex-class from-class
                                      :edge-type :have-to))))
      (if (not r)
          (%find-to-cameras graph from from-class (cdr r-list))
          (cons camera
                (%find-to-cameras graph from from-class (cdr r-list)))))))


(defgeneric find-to-cameras (graph obj &key modeler)
  (:method (graph (obj schema) &key modeler)
    (%find-to-cameras graph
                      obj
                      (class-name (class-of obj))
                      (shinra:find-r graph 'edge
                                     :from modeler
                                     :vertex-class 'camera
                                     :edge-type :have-to)))
  (:method (graph (obj campus) &key modeler)
    (%find-to-cameras graph
                      obj
                      (class-name (class-of obj))
                      (shinra:find-r graph 'edge
                                     :from modeler
                                     :vertex-class 'camera
                                     :edge-type :have-to))))

(defun get-to-camera (graph &key obj modeler code)
  (find-if #'(lambda (camera) (eq code (code camera)))
           (find-to-cameras graph obj :modeler modeler)))
