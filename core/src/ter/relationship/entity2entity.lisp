(in-package :ter)


(defun tx-make-relationship-rsc2rsc (graph from-rsc to-rsc type)
  (cond ((eq :comparative type)
         (tx-make-relationship-comparative graph from-rsc to-rsc))
        ((eq :recursion type) (tx-add-recursion graph from-rsc))
        (t (error "Not found relationship type. type=~S, from=~S, to=~S" type from-rsc to-rsc))))


(defun tx-make-relationship-rsc2evt (graph from-rsc to-evt type)
  (cond ((eq :inject type)
         (tx-make-relationship-inject graph from-rsc to-evt))
        (t (error "Not found relationship type. type=~S, from=~S, to=~S" type from-rsc to-evt))))


(defun tx-make-relationship-evt2evt (graph from to type)
  (cond ((eq :correspondence type)
         (tx-make-relationship-correspondence graph from to))
        ((eq :inject type)
         (tx-make-relationship-inject graph from to))
        (t (error "Not found relationship type. type=~S, from=~S, to=~S" type from to))))


(defun tx-make-relationship-evt2rsc (graph from-rsc to-rsc type)
  (cond ((eq :comparative type)
         (tx-make-relationship-comparative graph from-rsc to-rsc))
        (t (error "Not found relationship type. type=~S, from=~S, to=~S" type from-rsc to-rsc))))
