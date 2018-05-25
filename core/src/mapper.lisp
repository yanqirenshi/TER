(in-package :ter)

#|
 mapper は er と ter を紐付けるものです。
|#

(defun mapping-roule ()
  '((identifier          . column)
    (attribute           . column)
    (identifier-instance . column-instance)
    (attribute-instance  . column-instance)
    (resource            . table)
    (event               . table)
    (correspondence      . table)
    (comparative         . table)
    (recursion           . table)))

(defun assert-mapping (from to)
  (assert (find (cons (class-name (class-of from))
                      (class-name (class-of to)))
                (mapping-roule)
                :test 'equal)))

(defun tx-mapping (graph from to)
  (assert-mapping from to))

(defun find-mapping (graph &key from)
  (when from
    (shinra:find-r-vertex graph 'edge-map
                          :from from
                          :edge-type :map)))

(defun get-mapping (graph from to)
  (find-if #'(lambda (r)
               (= (up:%id r) (up:%id to)))
           (find-mapping graph :from from)))

(defun tx-make-mapping (graph from to)
  (or (get-mapping graph from to)
      (tx-make-edge graph 'edge-map graph from to :map)))
