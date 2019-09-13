(in-package :ter)

(defvar *campus-directory-root* nil)

(defun find-campus (graph &key system)
  (if system
      (shinra:find-r-vertex graph 'edge :from system
                                        :edge-type :have-to
                                        :vertex-class 'campus)
      (shinra:find-vertex graph 'campus)))

(defun get-campus (graph &key code)
  (car (shinra:find-vertex graph 'campus
                           :slot 'code
                           :value (if (stringp code)
                                      (str2keyword code)
                                      code))))

(defun campus-store-directory-pathname (code)
  (let ((root *campus-directory-root*))
    (assert root)
    (assert code)
    (assert (keywordp code))
    (merge-pathnames root (string-downcase (symbol-name code)))))

(defgeneric tx-make-campus (graph code &key name description)
  (:method (graph code &key name description)
    (assert (not (get-campus graph)))
    (shinra:tx-make-vertex graph 'campus
                           `((code ,code)
                             (name ,name )
                             (description ,description)
                             (store-directory ,(campus-store-directory-pathname code))))))


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

(defgeneric stop-campus-graph (campus)
  (:method ((campus campus))
    (let* ((code (code campus))
           (graph (gethash code *ter-campus-graphs*)))
      (when graph
        (shinra::stop graph)
        (remhash code *ter-campus-graphs*)))))

(defgeneric snapshot-campus-graph (campus)
  (:method ((campus campus))
    (let ((code (code campus)))
      (unless (gethash code *ter-campus-graphs*)
        (error "この campus には graph が存在しません。"))
      (up:snapshot (gethash code *ter-campus-graphs*)))))
