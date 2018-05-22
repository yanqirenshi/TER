(in-package :cl-user)
(defpackage ter.api.api-v1
  (:use :cl
        :caveman2
        :lack.middleware.validation
        :ter.api.render)
  (:export #:*api-v1*))
(in-package :ter.api.api-v1)

;;;;;
;;;;; Application
;;;;;
(defclass <router> (<app>) ())
(defvar *api-v1* (make-instance '<router>))
(clear-routing-rules *api-v1*)

;;;;;
;;;;; Routing rules
;;;;;
(defroute "/" ()
  (render-json (nobit@.api.controller::api-root)))

;;;;;
;;;;; Error pages
;;;;;
(defmethod on-exception ((app <router>) (code (eql 404)))
  (declare (ignore app))
  "404")
