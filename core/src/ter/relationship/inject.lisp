(in-package :ter)


(defun tx-inject-resouce-identifier (graph resouce-identifier event)
  (tx-add-identifier-instance graph
                              event
                              (list :code (code resouce-identifier)
                                    :name (name resouce-identifier)
                                    :data-type (data-type resouce-identifier))
                              :type :foreigner))

(defun tx-make-relationship-inject (graph from-rsc to-evt)
  (let ((from-identifier (get-native-identifier graph from-rsc)))
    (let ((to-identifier (tx-inject-resouce-identifier graph from-identifier to-evt)))
      (tx-make-relationship graph from-identifier to-identifier))))
