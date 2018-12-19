(in-package :ter.api.controller)

(defvar *session-key-name*
  "ghost.session")

(defun get-session-key (&key (request caveman2:*request*))
  (let ((cookie (caveman2:request-cookies request)))
    (cdr (assoc *session-key-name* cookie :test 'string=))))

(defun get-session (&key (session caveman2:*session*) (request caveman2:*request*))
  (let ((session-key (get-session-key :request request))
        (session session))
    (gethash session-key session)))

(defun session-modeler (graph &key (session caveman2:*session*) (request caveman2:*request*))
  (let ((session (get-session :session session :request request)))
    (ter:get-modeler graph :ghost-id session)))
