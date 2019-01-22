(in-package :cl-user)
(defpackage ter.api.router
  (:use #:cl
        #:caveman2
        #:lack.middleware.validation
        #:ter.api.render
        #:ter.api.controller)
  (:export #:*api-v1*))
(in-package :ter.api.router)

;;;;;
;;;;; Application
;;;;;
(defclass <router> (<app>) ())
(defvar *api-v1* (make-instance '<router>))
(clear-routing-rules *api-v1*)


;;;;;
;;;;; utilities
;;;;;
(defun assert-modeler (modeler)
  (unless modeler
    (throw-code 401)))

(defmacro with-graph-modeler ((graph modeler) &body body)
  `(let* ((,graph ter.db:*graph*)
          (,modeler (ter.api.controller::session-modeler ,graph)))
     (assert-modeler modeler)
     ,@body))


;;;;;
;;;;; Routing rules
;;;;;

;;;
;;; Environment
;;;
(defroute "/environment" ()
  (with-graph-modeler (graph modeler)
    (render-json (ter.api.controller::environments))))


(defroute ("/environment/er/schema/active" :method :POST) (&key _parsed)
  (with-graph-modeler (graph modeler)
    (let* ((schema-code (getf (jojo:parse (caar _parsed)) :|schema_code|))
           (schema (ter:get-schema graph :code schema-code)))
      (unless schema (throw-code 404))
      (render-json (ter.api.controller::set-active-schema schema)))))


(defun str2keyword (str)
  (when str
    (alexandria:make-keyword (string-upcase str))))


(defroute ("/camera/:camera_code/look-at" :method :POST) (&key camera_code |x| |y| |z|)
  (with-graph-modeler (graph modeler)
    (let* ((look-at (list :x |x| :y |y| :z |z|))
           (camera (ter::get-camera graph :code (str2keyword camera_code))))
      (unless camera (throw-code 404))
      (render-json (ter.api.controller::save-camera-look-at graph camera look-at)))))


(defroute ("/camera/:camera_code/magnification" :method :POST) (&key camera_code |magnification|)
  (with-graph-modeler (graph modeler)
    (let* ((val |magnification|)
           (camera (ter::get-camera graph :code (str2keyword camera_code))))
      (unless camera (throw-code 404))
      (render-json (ter.api.controller::save-camera-magnification graph camera val)))))


;;;
;;; er
;;;
(defroute ("/er/:schema_code/tables/:code/position" :method :POST) (&key schema_code code |x| |y| |z|)
  (with-graph-modeler (graph modeler)
    (let ((code (alexandria:make-keyword code))
          (schema (ter:get-schema graph :code (str2keyword schema_code))))
      (render-json (save-er-position schema code |x| |y| |z|)))))


(defroute ("/er/:schema_code/tables/:code/size" :method :POST) (&key schema_code code |w| |h|)
  (with-graph-modeler (graph modeler)
    (let ((code (alexandria:make-keyword (string-upcase code)))
          (schema (ter:get-schema graph :code (str2keyword schema_code))))
      (render-json (save-er-size schema code |w| |h|)))))


(defroute "/er/:schema_code" (&key schema_code)
  (with-graph-modeler (graph modeler)
    (let* ((schema_code (alexandria:make-keyword (string-upcase schema_code)))
           (schema (ter:get-schema graph :code schema_code)))
      (render-json (nconc (find-er schema)
                          (list :cameras (ter::find-schema-camera graph schema)))))))

(defroute "/er/:schema_code/nodes" (&key schema_code)
  (with-graph-modeler (graph modeler)
    (let* ((schema_code (alexandria:make-keyword (string-upcase schema_code)))
           (schema (ter:get-schema graph :code schema_code)))
      (render-json (nconc (find-er-vertexes schema)
                          (list :cameras (ter::find-schema-camera graph schema)))))))

(defroute "/er/:schema_code/edges" (&key schema_code)
  (with-graph-modeler (graph modeler)
    (let* ((schema_code (alexandria:make-keyword (string-upcase schema_code)))
           (schema (ter:get-schema graph :code schema_code)))
      (render-json (find-er-edges schema)))))


(defroute ("/er/:schema-code/tables/:table-code/columns/:column-code/logical-name" :method :POST)
    (&key schema-code table-code column-code |logical_name|)
  (with-graph-modeler (graph modeler)
    (let* ((logical-name |logical_name|)
           (schema (ter:get-schema graph :code (str2keyword schema-code))))
      (unless schema (throw-code 404))
      (render-json (save-column-instance-logical-name schema
                                                      (str2keyword table-code)
                                                      (str2keyword column-code)
                                                      logical-name)))))

;;;;;
;;;;; table description
;;;;;
(defroute ("/er/:schema-code/tables/:table-code/description" :method :POST)
    (&key schema-code table-code |contents|)
  (with-graph-modeler (graph modeler)
    (let* ((schema (ter:get-schema graph :code (str2keyword schema-code)))
           (table-code (str2keyword table-code))
           (description |contents|))
      (unless schema (throw-code 404))
      (render-json (save-table-description schema table-code description)))))


;;;;;
;;;;; column description
;;;;;
(defroute ("/er/:schema-code/columns/instance/:id/description" :method :POST)
    (&key schema-code id |contents|)
  (with-graph-modeler (graph modeler)
    (let* ((schema (ter:get-schema graph :code (str2keyword schema-code)))
           (%id (parse-integer id))
           (description |contents|))
      (unless schema (throw-code 404))
      (render-json (save-column-instance-description schema %id description)))))


;;;;;;;;
;;;;;;;; TER
;;;;;;;;
(defun get-campus (graph campus-code)
  (or (ter:get-campus graph :code (str2keyword campus-code))
      (throw-code 404)))

(defroute "/ter/:campus-code/environment" (&key campus-code)
  (with-graph-modeler (graph modeler)
    (let ((campus (get-campus graph campus-code)))
      (render-json (list :cameras (ter:find-ter-camera graph :campus campus :modeler modeler))))))

;;;
;;; entity
;;;
(defroute "/ter/:campus-code/entities" (&key campus-code)
  (with-graph-modeler (graph modeler)
    (let ((campus (get-campus graph campus-code)))
      (render-json (find-entities campus)))))

(defroute ("/ter/:campus-code/entities/:entity-code/location" :method :post)
    (&key campus-code entity-code |x| |y| |z|)
  (with-graph-modeler (graph modeler)
    (let* ((campus (get-campus graph campus-code))
           (entity-id (parse-integer entity-code))
           (entity (get-entity campus :%id entity-id))
           (x |x|)
           (y |y|)
           (z |z|))
      (unless campus (throw-code 404))
      (unless entity (throw-code 404))
      (render-json (save-entity-position campus entity x y z)))))


;;;
;;; identifiers
;;;
(defroute "/ter/:campus-code/identifiers" (&key campus-code)
  (with-graph-modeler (graph modeler)
    (let ((campus (get-campus graph campus-code)))
      (render-json (find-identifier-instances campus)))))

;;;
;;; attributes
;;;
(defroute "/ter/:campus-code/attributes" (&key campus-code)
  (with-graph-modeler (graph modeler)
    (let ((campus (get-campus graph campus-code)))
      (render-json (find-attributes-instances campus)))))

;;;
;;; ports
;;;
(defroute "/ter/:campus-code/ports" (&key campus-code)
  (with-graph-modeler (graph modeler)
    (let ((campus (get-campus graph campus-code)))
      (render-json (find-entities-ports campus)))))

(defroute ("/ter/:campus-code/ports/:port-id/location" :method :post) (&key campus-code port-id |degree|)
  (with-graph-modeler (graph modeler)
    (let ((campus (get-campus graph campus-code))
          (degree |degree|))
      (render-json (save-port-ter-location campus
                                           (parse-integer port-id)
                                           degree)))))


;;;
;;; edges
;;;
(defroute "/ter/:campus-code/edges" (&key campus-code)
  (with-graph-modeler (graph modeler)
    (let ((campus (get-campus graph campus-code)))
      (render-json (find-edge-ters campus)))))


;;;
;;; Graph
;;;
(defroute "/graph" ()
  (with-graph-modeler (graph modeler)
    (render-json (ter.api.controller:find-graph graph))))


;;;
;;; rpc
;;;
(defroute "/rpc/snapshot/all" ()
  (with-graph-modeler (graph modeler)
    (let ((start (local-time:now)))
      (ter.api.controller::snapshot-all)
      (render-json (list :start (local-time:format-timestring nil start)
                         :end   (local-time:format-timestring nil (local-time:now)))))))


;;;;;
;;;;; Error pages
;;;;;
(defmethod on-exception ((app <router>) (code (eql 404)))
  (declare (ignore app))
  "404")
