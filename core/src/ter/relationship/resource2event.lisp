(in-package :ter)

(defun tx-inject-resouce-identifier (graph resouce-identifier event)
  (tx-add-identifier-instance graph
                              event
                              (list :code (code resouce-identifier)
                                    :name (name resouce-identifier)
                                    :data-type (data-type resouce-identifier))
                              :type :foreigner))

(defun tx-make-relationship-rsc2evt-to (graph from-rsc to-evt)
  (let ((from-identifier (get-native-identifier graph from-rsc)))
    (let ((to-identifier (tx-inject-resouce-identifier graph from-identifier to-evt)))
      (tx-make-relationship graph from-identifier to-identifier))))


(defun sample-tx-make-relationship-rsc2rsc-th (graph from-rsc to-rsc)
  (let ((from-identifier (get-native-identifier graph from-rsc))
        (to-identifier   (get-native-identifier graph to-rsc))
        (code            (format nil "TH_~a_~a"     (code from-rsc) (code to-rsc)))
        (name            (format nil "~a ~a 対照表" (name from-rsc) (name to-rsc))))
    (multiple-value-bind (th th-from-identifier th-to-identifier)
        (tx-make-comparative graph code name
                             :from from-identifier
                             :to   to-identifier)
      (declare (ignore th))
      (tx-make-relationship graph from-identifier th-from-identifier)
      (tx-make-relationship graph to-identifier   th-to-identifier))))
