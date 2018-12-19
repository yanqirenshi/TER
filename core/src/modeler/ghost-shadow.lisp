(in-package :ter)

(defun ensuer-integer (v)
  (cond ((numberp v) v)
        ((stringp (parse-integer v)))
        (t (error "invalid integer"))))

(defun get-ghost-shadow (graph &key ghost-id)
  (car (shinra:find-vertex graph 'ghost-shadow
                           :slot 'ghost-id
                           :value (ensuer-integer ghost-id))))

(defgeneric tx-make-ghost-shadow (graph ghost-id)

  (:method (graph (ghost-id string))
    (tx-make-ghost-shadow graph (parse-integer ghost-id)))

  (:method (graph (ghost-id integer))
    (when (get-ghost-shadow graph :ghost-id ghost-id)
      (error "Aledy exist Ghost. ghost-id=~S" ghost-id))
    (shinra:tx-make-vertex graph 'ghost-shadow
                           `((ghost-id ,ghost-id)))))
