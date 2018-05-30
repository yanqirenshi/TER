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
;;; schema
;;;
(defroute "/schema" ()
  (render-json (ter::get-schema ter.db:*graph*)))

;;;
;;; er
;;;
(defroute "/er" ()
  (render-json (ter.api.controller:find-er ter.db:*graph*)))

(defroute "/er/tables" ()
  (render-json (ter.api.controller:finder-er-tables)))

(defroute "/er/tables/:code" ()
  (render-json (list :test "/er/tables/:code")))

(defroute ("/er/tables/:code/position" :method :POST) (&key code _parsed)
  (let ((position (jojo:parse (car (first _parsed))))
        (code (alexandria:make-keyword code)))
    (render-json (ter.api.controller::save-er-position code position))))

(defroute "/er/columns" ()
  (render-json (ter.api.controller:finder-er-columns)))

(defroute "/er/columns/:code"  ()
  (render-json (list :test "/er/columns/:code")))

(defroute "/er/column-instances"  ()
  (render-json (ter.api.controller:finder-er-column-instances)))

(defroute "/er/column-instances/:code"  ()
  (render-json (list :test "/er/column-instances/:code")))

(defroute "/er/relashonships"  ()
  (render-json (ter.api.controller:finder-er-relashonships)))

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
