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
  (render-json (ter.api.controller::environments)))

(defroute ("/environment/er/schema/active" :method :POST) (&key _parsed)
  (let* ((graph ter.db:*graph*)
         (schema-code (getf (jojo:parse (caar _parsed)) :|schema_code|))
         (schema (ter::get-schema graph :code schema-code)))
    (unless schema (throw-code 404))
    (render-json (ter.api.controller::set-active-schema schema))))

(defun str2keyword (str)
  (when str
    (alexandria:make-keyword (string-upcase str))))

(defroute ("/camera/:camera_code/look-at" :method :POST) (&key camera_code _parsed)
  (let* ((look-at (jojo:parse (caar _parsed)))
         (graph ter.db:*graph*)
         (camera (ter::get-camera graph :code (str2keyword camera_code))))
    (unless camera (throw-code 404))
    (render-json (ter.api.controller::save-camera-look-at graph camera look-at))))

(defroute ("/camera/:camera_code/magnification" :method :POST) (&key camera_code _parsed)
  (let* ((val (getf (jojo:parse (caar _parsed)) :|magnification|))
         (graph ter.db:*graph*)
         (camera (ter::get-camera graph :code (str2keyword camera_code))))
    (unless camera (throw-code 404))
    (render-json (ter.api.controller::save-camera-magnification graph camera val))))


;;;
;;; er
;;;
(defroute ("/er/:schema_code/tables/:code/position" :method :POST) (&key schema_code code _parsed)
  (let ((position (jojo:parse (car (first _parsed))))
        (code (alexandria:make-keyword code))
        (schema (ter::get-schema ter.db:*graph* :code (str2keyword schema_code))))
    (render-json (ter.api.controller::save-er-position schema code position))))

(defroute "/er/:schema_code" (&key schema_code)
  (let* ((graph ter.db:*graph*)
         (schema_code (alexandria:make-keyword (string-upcase schema_code)))
         (schema (ter::get-schema graph :code schema_code)))
    (render-json (nconc (ter.api.controller::find-er schema)
                        (list :cameras (ter::find-schema-camera graph schema))))))


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
