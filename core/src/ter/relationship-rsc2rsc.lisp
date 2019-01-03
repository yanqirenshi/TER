(in-package :ter)

(defun tx-make-relationship-rsc2rsc-th (graph from-rsc to-rsc)
  (let ((from-identifier (get-native-identifier graph from-rsc))
        (to-identifier   (get-native-identifier graph to-rsc))
        (code            (format nil "TH_~a_~a"     (code from-rsc) (code to-rsc)))
        (name            (format nil "~a ~a 対照表" (name from-rsc) (name to-rsc))))
    (multiple-value-bind (th th-from-identifier th-to-identifier)
        (tx-make-comparative graph code name
                             :from from-identifier
                             :to   to-identifier)
      (declare (ignore th))
      (tx-make-relationships2 graph from-identifier th-from-identifier)
      (tx-make-relationships2 graph to-identifier   th-to-identifier))))
