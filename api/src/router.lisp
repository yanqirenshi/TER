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
;;; er
;;;
(defroute "/er/entities" ()
  (render-json (ter.api.controller:finder-er-entities)))

(defroute "/er/entities/:code" ()
  (render-json (list :test "/er/entities/:code")))

(defroute "/er/attributes" ()
  (render-json (ter.api.controller:finder-er-attributes)))

(defroute "/er/attributes/:code"  ()
  (render-json (list :test "/er/attributes/:code")))

(defroute "/er/attribute-entitis"  ()
  (render-json (ter.api.controller:finder-er-attribute-entitis)))

(defroute "/er/attribute-entitis/:code"  ()
  (render-json (list :test "/er/attribute-entitis/:code")))

(defroute "/er/relashonships"  ()
  (render-json (ter.api.controller:finder-er-relashonships)))

;;;
;;; ter
;;;
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


;;;;;
;;;;; Error pages
;;;;;
(defmethod on-exception ((app <router>) (code (eql 404)))
  (declare (ignore app))
  "404")
