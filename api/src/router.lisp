(in-package :cl-user)
(defpackage ter.api.router
  (:use #:cl
        #:caveman2
        #:lack.middleware.validation
        #:ter.api.render
        #:ter.api.controller
        #:ter.api.utilities)
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
(defroute "/environments" ()
  (with-graph-modeler (graph modeler)
    (render-json (ter.api.controller::environments graph modeler))))


;;;
;;; er
;;;
(defroute ("/er/schemas/:schema-code/camera/:camera-code/look-at" :method :POST)
    (&key schema-code camera-code |x| |y| |z|)
  (declare (ignore |z|))
  (with-graph-modeler (graph modeler)
    (let* ((x |x|)
           (y |y|)
           (schema (get-schema graph schema-code))
           (camera-code (str2keyword camera-code)))
      (render-json (save-er-camera-look-at schema modeler camera-code x y)))))


(defroute ("/er/schemas/:schema-code/camera/:camera-code/magnification" :method :POST)
    (&key schema-code camera-code |magnification|)
  (with-graph-modeler (graph modeler)
    (let ((schema-code   (validate schema-code     :string :require t))
          (camera-code   (validate camera-code     :string :require t))
          (magnification (validate |magnification| :float  :require t)))
      (let ((schema      (get-schema graph schema-code))
            (camera-code (str2keyword camera-code)))
        (assert-path-object schema)
        (render-json (save-er-camera-magnification schema
                                                   modeler
                                                   camera-code
                                                   magnification))))))


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


(defroute "/er/:schema_code/environments" (&key schema_code)
  (with-graph-modeler (graph modeler)
    (let* ((system (ter::get-system graph :code (str2keyword schema_code)))
           (schema_code (alexandria:make-keyword (string-upcase schema_code)))
           (schema (ter:get-schema graph :code schema_code)))
      (render-json (er-environment-at-modeler-system-schema graph modeler system schema)))))

(defroute "/er/:schema_code/nodes" (&key schema_code)
  (with-graph-modeler (graph modeler)
    (let* ((schema_code (alexandria:make-keyword (string-upcase schema_code)))
           (schema (ter:get-schema graph :code schema_code)))
      (render-json (find-er-vertexes schema)))))

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
(defroute "/ter/:campus-code/environments" (&key campus-code)
  (with-graph-modeler (graph modeler)
    (let ((system (ter::get-system graph :code (str2keyword campus-code)))
          (campus (get-campus graph campus-code)))
      (unless system (throw-code 404))
      (unless campus (throw-code 404))
      (render-json (ter-environment-at-modeler-system-campus graph modeler system campus)))))


(defroute ("/ter/:campus-code/cameras/:camera-code/look-at" :method :post)
    (&key campus-code camera-code |x| |y|)
  (with-graph-modeler (graph modeler)
    (let ((campus (get-campus graph campus-code))
          (camera-code (str2keyword camera-code)))
      (render-json (save-ter-camera-look-at campus modeler camera-code |x| |y|)))))


(defroute ("/ter/:campus-code/cameras/:camera-code/magnification" :method :post)
    (&key campus-code camera-code |magnification|)
  (with-graph-modeler (graph modeler)
    (let ((campus (get-campus graph campus-code))
          (camera-code (str2keyword camera-code)))
      (render-json (save-ter-camera-magnification campus modeler camera-code |magnification|)))))


;;;
;;; entity
;;;
(defroute "/ter/:campus-code/entities" (&key campus-code)
  (with-graph-modeler (graph modeler)
    (let ((campus (get-campus graph campus-code)))
      (unless campus (throw-code 404))
      (render-json (find-entities campus)))))

(defroute ("/systems/:sytem-id/campuses/:campus-id/entities" :method :post)
    (&key sytem-id campus-id |type| |code| |name| |description|)
  (with-graph-modeler (graph modeler)
    (render-json (list sytem-id campus-id |type| |code| |name| |description|))))

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
;;; system
;;;
(defroute ("/systems" :method :post) (&key |code| |name| |description|)
  (with-graph-modeler (graph modeler)
    (let ((code (alexandria:make-keyword (string-upcase |code|)))
          (name |name|)
          (description |description|))
      (render-json (create-system graph modeler
                                  :code code
                                  :name name
                                  :description description)))))

(defroute ("/systems/:id/active" :method :post) (&key id)
  (with-graph-modeler (graph modeler)
    (let* ((id (parse-integer id))
           (system (ter::get-system graph :%id id)))
      (unless system (throw-code 404))
      (render-json (ter.api.controller:set-active-system graph modeler system)))))

;;;
;;; edges
;;;
(defroute "/ter/:campus-code/edges" (&key campus-code)
  (with-graph-modeler (graph modeler)
    (let ((campus (get-campus graph campus-code)))
      (render-json (find-edge-ters campus)))))


;;;
;;; rpc
;;;
(defroute "/rpc/snapshot/all" ()
  (with-graph-modeler (graph modeler)
    (let ((start (local-time:now)))
      (ter.api.controller::snapshot-all)
      (render-json (list :start (local-time:format-timestring nil start)
                         :end   (local-time:format-timestring nil (local-time:now)))))))


;;;
;;; pages
;;;
(defroute "/pages/managements" ()
  (with-graph-modeler (graph modeler)
    (render-json (pages-basic graph modeler))))

(defroute "/pages/systems" ()
  (with-graph-modeler (graph modeler)
    (render-json (pages-systems graph modeler))))

(defroute "/pages/modelers" ()
  (with-graph-modeler (graph modeler)
    (render-json (pages-modelers graph modeler))))

(defroute "/pages/systems/:id" (&key id)
  (with-graph-modeler (graph modeler)
    (let ((system (ter::get-system graph :%id (parse-integer id))))
      (unless system (throw-code 404))
      (render-json (pages-system graph system modeler)))))


;;;;;
;;;;; Error pages
;;;;;
(defmethod on-exception ((app <router>) (code (eql 404)))
  (declare (ignore app))
  "404")
