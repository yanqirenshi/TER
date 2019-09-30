(in-package :ter)

(defun tx-make-modeler (graph &key name)
  (shinra:tx-make-vertex graph 'modeler `((name ,name))))


(defgeneric tx-make-modeler-with-ghost (graph ghost &key name)
  (:method (graph (ghost-id string) &key name)
    (tx-make-modeler-with-ghost graph
                                (parse-integer ghost-id)
                                :name name))

  (:method (graph (ghost-id integer) &key name)
    (let ((ghost-shadow (get-ghost-shadow graph :ghost-id ghost-id)))
      (when ghost-shadow (error "Aledy exist ghost-shadow. %id=~S" ghost-id))
      (tx-make-modeler-with-ghost graph
                                  (tx-make-ghost-shadow graph ghost-id)
                                  :name name)))

  (:method (graph (ghost-shadow ghost-shadow) &key name)
    (let ((new-modeler (tx-make-modeler graph :name name)))
      (tx-make-edge-ghost-shadow2modeler graph ghost-shadow new-modeler)
      new-modeler)))


(defun find-modeler (graph &key system ghost-shadow)
  (cond (system
         (shinra:find-r-vertex graph 'edge-grant
                               :from system
                               :vertex-class 'modeler))
        (ghost-shadow
         (shinra:find-r-vertex graph 'edge
                               :from ghost-shadow
                               :vertex-class 'modeler
                               :edge-type :have-to))
        (t (shinra:find-vertex graph 'modeler))))

(defun get-all-modelers (graph)
  (shinra:find-vertex graph 'modeler))

(defun get-modeler (graph &key ghost-id ghost-shadow %id)
  (cond (%id (shinra:get-vertex-at graph 'modeler :%id %id))
        (ghost-id
         (let ((ghost-shadow (get-ghost-shadow graph :ghost-id ghost-id)))
           (get-modeler graph :ghost-shadow ghost-shadow)))
        (ghost-shadow
         (car (find-modeler graph :ghost-shadow ghost-shadow)))))
