(in-package :ter)

(defun %add-port (graph from)
  (let ((port (tx-make-port graph)))
    (shinra:tx-make-edge graph 'edge-ter from port :have)
    port))

(defgeneric add-port (graph from)
  (:method (graph (from resource))       (%add-port graph from))
  (:method (graph (from event))          (%add-port graph from))
  (:method (graph (from comparative))    (%add-port graph from))
  (:method (graph (from correspondence)) (%add-port graph from))
  (:method (graph (from recursion))      (%add-port graph from))
  (:method (graph (from recursion))      (%add-port graph from)))

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

(defgeneric port-p (obj)
  (:method ((obj port)) t)
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
                  (port-p from))))
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
                  (port-p to))))
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

(defun tx-make-relationships (graph &rest in_statements)
  (let ((statements (parse-make-r-statemnts in_statements)))
    (assert-make-r-statemnts statements)
    (%tx-make-relationships graph statements)))
