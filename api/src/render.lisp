(in-package :cl-user)
(defpackage ter.api.render
  (:use :cl)
  (:import-from #:caveman2
                #:*response*
                #:response-headers)
  (:export #:render
           #:render-json))
(in-package :nobit@.api.render)

(defun render-json (object)
  (setf (getf (response-headers *response*) :content-type) "application/json")
  (jonathan:to-json object))
