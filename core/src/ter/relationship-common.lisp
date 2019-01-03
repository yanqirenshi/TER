(in-package :ter)

(defun find-ter-all-edges (graph &key (class 'edge-ter))
  (gethash (pool-key-ra class)
           (up::root-objects graph)))

;;;;;
;;;;; tx-make-relationships
;;;;;
(defgeneric entity-p (obj)
  (:method ((obj resource)) t)
  (:method ((obj event)) t)
  (:method ((obj correspondence)) t)
  (:method ((obj comparative)) t)
  (:method ((obj recursion)) t)
  (:method (obj) nil))

(defgeneric port-ter-p (obj)
  (:method ((obj port-ter)) t)
  (:method (obj) nil))

(defun parse-make-r-statemnts (statements)
  (when statements
    (cond ((>= 3 (length statements))
           (list statements))
          (t (cons (subseq statements 0 3)
                   (parse-make-r-statemnts (subseq statements 2)))))))

(defun assert-make-r-statemnts (statements)
  (when-let ((statement (car statements)))
    ;; common
    (assert (listp statement))
    (assert (= 3 (length statement)))
    ;; from
    (let ((from (first statement)))
      (assert (or (entity-p from)
                  (port-ter-p from))))
    ;; center
    (let ((center (second statement)))
      (assert (listp center))
      (assert (= 2 (length center)))
      (assert (not (find-if #'(lambda (d)
                                (not (keywordp d)))
                            center))))
    ;; to
    (let ((to (first statement)))
      (assert (or (entity-p to)
                  (port-ter-p to))))
    (assert-make-r-statemnts (cdr statements))))

(defun splist-center-pos (center &optional (operators '(:<- :->)))
  (when-let ((operator (car operators)))
    (cond ((eq operator (first center)) 0)
          ((eq operator (second center)) 1)
          (t (splist-center-pos center (cdr operators))))))

(defun splist-center (center)
  (let ((pos    (splist-center-pos center))
        (first  (first  center))
        (second (second center)))
    (cond ((= 0 pos) (list :direction first  :type second))
          ((= 1 pos) (list :direction second :type first))
          (t (error "splist-center!")))))

(defun %tx-make-relationships (graph statements)
  (when-let ((statement (car statements)))
    (let* ((a      (first statement))
           (center (splist-center (second statement)))
           (b      (third statement))
           (edge-type (getf center :type))
           (direction (getf center :direction)))
      (cond ((eq :-> direction) (shinra:tx-make-edge graph 'edge-ter a b edge-type))
            ((eq :<- direction) (shinra:tx-make-edge graph 'edge-ter b a edge-type)))
      (%tx-make-relationships graph (cdr statements)))))

;; TODO: これは廃止したほうがいいね
;; (defun tx-make-relationships (graph &rest in_statements)
;;   (let ((statements (parse-make-r-statemnts in_statements)))
;;     (assert-make-r-statemnts statements)
;;     (%tx-make-relationships graph statements)))


(defgeneric tx-make-relationships2 (graph from to)
  (:method (graph (from port-ter) (to port-ter))
    (shinra:tx-make-edge graph 'edge-ter from to :->))

  (:method (graph (from identifier-instance) (to identifier-instance))
    (tx-make-relationships2 graph
                            (add-port graph from)
                            (add-port graph to))))
