(in-package :ter)

(defun find-campus (graph)
  (shinra:find-vertex graph 'campus))

(defun get-campus (graph &key code)
  (car (shinra:find-vertex graph 'campus
                           :slot 'code
                           :value (if (stringp code)
                                      (str2keyword code)
                                      code))))

(defgeneric tx-make-campus (graph code &key name description)
  (:method (graph code &key name description)
    (assert (not (get-campus graph)))
    (shinra:tx-make-vertex graph 'campus
                           `((code ,code)
                             (name ,name )
                             (description ,description)))))


;;;;;
;;;;; Campus graph
;;;;;
(defvar *ter-campus-graphs* (make-hash-table))

(defgeneric start-campus-graph (campus)
  (:method ((campus campus))
    (let ((code (code campus))
          (store-dir (store-directory campus)))
      (when (gethash code *ter-campus-graphs*)
        (error "この campus の graph は既に開始しています。"))
      (setf (gethash code *ter-campus-graphs*)
            (shinra:make-banshou 'shinra:banshou store-dir)))))

(defgeneric get-campus-graph (campus)
  (:method ((campus-code symbol))
    (get-campus-graph (get-campus *graph* :code campus-code)))
  (:method ((campus campus))
    (let ((graph (gethash (code campus) *ter-campus-graphs*)))
      (or graph
          (start-campus-graph campus)))))

(defgeneric snapshot-campus-graph (campus)
  (:method ((campus campus))
    (let ((code (code campus)))
      (unless (gethash code *ter-campus-graphs*)
        (error "この campus には graph が存在しません。"))
      (up:snapshot (gethash code *ter-campus-graphs*)))))
