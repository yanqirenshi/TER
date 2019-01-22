(in-package :ter)

(defun %find-ter-cameras (graph campus r-list)
  (when-let ((r (car r-list)))
    (let ((camera (getf r :vertex)))
      (if (not (shinra:find-r graph 'edge-ter :to camera :vertex-class 'campus :edge-type :have-to))
          (%find-ter-cameras graph campus (cdr r-list))
          (cons camera
                (%find-ter-cameras graph campus (cdr r-list)))))))

(defun find-ter-cameras (graph &key campus modeler)
  (%find-ter-cameras graph
                   campus
                   (shinra:find-r graph 'edge-ter :from modeler :vertex-class 'camera :edge-type :have-to)))

(defun %assert-not-exist-ter-camera (code cameras)
  (when cameras
    (let ((camera (car cameras)))
      (when (eq code (code camera))
        (error "exist camera. code=~S, camera=~S" code camera))
      (%assert-not-exist-ter-camera code (cdr cameras)))))

(defun assert-not-exist-ter-camera (graph code campus modeler)
  (%assert-not-exist-ter-camera code (find-ter-cameras graph :campus campus :modeler modeler)))

(defgeneric tx-make-ter-camera (graph code campus modeler)
  (:method (graph (code symbol) (campus campus) (modeler modeler))
    (assert-not-exist-ter-camera graph code campus modeler)
    (let ((camera (tx-make-camera graph code)))
      (values camera
              (shinra:tx-make-edge graph 'edge-ter campus  camera :have-to)
              (shinra:tx-make-edge graph 'edge-ter modeler camera :have-to)))))
