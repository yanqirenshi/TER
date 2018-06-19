(in-package :cl-user)
(defpackage ter.api.router
  (:use #:cl
        #:caveman2
        #:lack.middleware.validation
        #:ter.api.render)
  (:export #:*api-v1*))
(in-package :ter.api.router)

;;;;;
;;;;; Application
;;;;;
(defclass <router> (<app>) ())
(defvar *api-v1* (make-instance '<router>))
(clear-routing-rules *api-v1*)

;;;;;
;;;;; Routing rules
;;;;;

;;;
;;; Environment
;;;
(defroute "/environment" ()
  (render-json (list :schemas (ter::find-schema ter.db:*graph*)
                     :camera (ter::get-camera ter.db:*graph* :code :default))))

;;;
;;; er
;;;
(defroute ("/er/:schema_code/tables/:code/position" :method :POST) (&key schema_code code _parsed)
  (let ((position (jojo:parse (car (first _parsed))))
        (code (alexandria:make-keyword code))
        (schema (ter::get-schema ter.db:*graph* :code (alexandria:make-keyword (string-upcase schema_code)))))
    (render-json (ter.api.controller::save-er-position schema code position))))

(defroute "/er/:schema_code" (&key schema_code)
  (let ((schema (ter::get-schema ter.db:*graph* :code (alexandria:make-keyword (string-upcase schema_code)))))
    (render-json (ter.api.controller::find-er schema))))


;;;
;;; ter
;;;
(defroute "/ter" ()
  (render-json (ter.api.controller:find-ter)))

(defroute "/ter/resources"                   () (render-json (list :test "/resources")))
(defroute "/ter/resources/:code"             () (render-json (list :test "/resources/:code")))
(defroute "/ter/resources/:code/identifiers" () (render-json (list :test "/resources/:code/identifiers")))
(defroute "/ter/resources/:code/attributes"  () (render-json (list :test "/resources/:code/attributes")))

(defroute "/ter/events"                   ()  (render-json (list :test "/events")))
(defroute "/ter/events/:code"             () (render-json (list :test "/events/:code")))
(defroute "/ter/events/:code/identifiers" ()  (render-json (list :test "/events/:code/identifiers")))
(defroute "/ter/events/:code/attributes"  ()  (render-json (list :test "/events/:code/identifiers")))

(defroute "/ter/identifiers"       () (render-json (list :test "/identifiers")))
(defroute "/ter/identifiers/:code" () (render-json (list :test "/identifiers/:code")))

(defroute "/ter/attributes"        () (render-json (list :test "/events")))
(defroute "/ter/attributes/:code"  () (render-json (list :test "/events/:code")))


;;;
;;; Graph
;;;
(defroute "/graph" ()
  (render-json (ter.api.controller:find-graph ter.db:*graph*)))


;;;;;
;;;;; Error pages
;;;;;
(defmethod on-exception ((app <router>) (code (eql 404)))
  (declare (ignore app))
  "404")
