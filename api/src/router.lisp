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
(defroute "/er/schemas/:schema-id/environments" (&key schema-id)
  (with-graph-modeler (graph modeler)
    (let ((schema-id (validate schema-id :integer :require t)))
      (let ((schema (get-schema-by-modeler graph modeler :schema-id schema-id)))
        (assert-path-object schema)
        (assert-authority graph schema modeler :owner :writer :reader)
        (render-json (er-environment-at-modeler-schema graph modeler schema))))))


(defroute "/er/schemas/:schema-id/nodes" (&key schema-id)
  (with-graph-modeler (graph modeler)
    (let ((schema-id (validate schema-id :integer :require t)))
      (let ((schema (get-schema-by-modeler graph modeler :schema-id schema-id)))
        (assert-path-object schema)
        (assert-authority graph schema modeler :owner :writer :reader)
        (render-json (find-er-vertexes schema))))))


(defroute "/er/schemas/:schema-id/edges" (&key schema-id)
  (with-graph-modeler (graph modeler)
    (let ((schema-id (validate schema-id :integer :require t)))
      (let ((schema (get-schema-by-modeler graph modeler :schema-id schema-id)))
        (assert-path-object schema)
        (assert-authority graph schema modeler :owner :writer :reader)
        (render-json (find-er-edges schema))))))


(defroute ("/er/schemas/:schema-id/cameras/:camera-id/look-at" :method :POST)
    (&key schema-id camera-id |x| |y|)
  (with-graph-modeler (graph modeler)
    (let ((schema-id (validate schema-id :integer :require t))
          (camera-id (validate camera-id :integer :require t))
          (x         (validate |x|       :float :require t))
          (y         (validate |y|       :float :require t)))
      (let* ((schema (get-schema-by-modeler graph modeler :schema-id schema-id))
             (camera (get-camera-by-schema  graph schema  :camera-id camera-id)))
        (assert-path-object schema)
        (assert-path-object camera)
        (assert-authority graph schema modeler :owner :writer :reader)
        (render-json (save-er-camera-look-at camera x y
                                             :graph   graph
                                             :modeler modeler))))))


(defroute ("/er/schemas/:schema-id/cameras/:camera-id/magnification" :method :POST)
    (&key schema-id camera-id |magnification|)
  (with-graph-modeler (graph modeler)
    (let ((schema-id     (validate schema-id       :integer :require t))
          (camera-id     (validate camera-id       :integer :require t))
          (magnification (validate |magnification| :float   :require t)))
      (let* ((schema (get-schema-by-modeler graph modeler :schema-id schema-id))
             (camera (get-camera-by-schema  graph schema  :camera-id camera-id)))
        (assert-path-object schema)
        (assert-path-object camera)
        (assert-authority graph schema modeler :owner :writer :reader)
        (render-json (save-er-camera-magnification camera magnification
                                                   :graph  graph
                                                   :modeler modeler))))))


(defroute ("/er/schemas/:schema-id/tables/:table-id/position" :method :POST)
    (&key schema-id table-id |x| |y| |z|)
  (with-graph-modeler (graph modeler)
    (let ((schema-id (validate schema-id :integer :require t))
          (table-id  (validate table-id  :integer :require t))
          (x         (validate |x|       :float   :require t))
          (y         (validate |y|       :float   :require t))
          (z         (validate |z|       :float   :require t)))
      (let* ((schema (get-schema-by-modeler graph modeler :schema-id schema-id))
             (table  (get-table-by-schema   schema        :table-id  table-id)))
        (assert-path-object schema)
        (assert-path-object table)
        (assert-authority graph schema modeler :owner :writer)
        (render-json (save-er-position schema table x y z))))))


(defroute ("/er/schemas/:schema-id/tables/:table-id/size" :method :POST)
    (&key schema-id table-id |w| |h|)
  (with-graph-modeler (graph modeler)
    (let ((schema-id (validate schema-id :integer :require t))
          (table-id  (validate table-id  :integer :require t))
          (w         (validate |w|       :float   :require t))
          (h         (validate |h|       :float   :require t)))
      (let* ((schema (get-schema-by-modeler graph modeler :schema-id schema-id))
             (table  (get-table-by-schema   schema        :table-id  table-id)))
        (assert-path-object schema)
        (assert-path-object table)
        (assert-authority graph schema modeler :owner :writer)
        (render-json (save-er-size schema table w h))))))


(defroute ("/er/schemas/:schema-id/tables/:table-id/description" :method :POST)
    (&key schema-id table-id |contents|)
  (with-graph-modeler (graph modeler)
    (let ((schema-id   (validate schema-id :integer :require t))
          (table-id    (validate table-id  :integer :require t))
          (description (validate |contents| :string            :url-decode t)))
      (let* ((schema (get-schema-by-modeler graph modeler :schema-id schema-id))
             (table  (get-table-by-schema   schema        :table-id  table-id)))
        (assert-path-object schema)
        (assert-path-object table)
        (assert-authority graph schema modeler :owner :writer)
        (render-json (save-table-description schema table description))))))


(defroute ("/er/schemas/:schema-id/tables/:table-id/column-instances/:column-id/logical-name" :method :POST)
    (&key schema-id table-id column-id |logical_name|)
  (with-graph-modeler (graph modeler)
    (let ((schema-id (validate schema-id      :integer :require t))
          (table-id  (validate table-id       :integer :require t))
          (column-id (validate column-id      :integer :require t))
          (logical-name (validate |logical_name| :string  :require t)))
      (let* ((schema          (get-schema-by-modeler        graph modeler :schema-id schema-id))
             (table           (get-table-by-schema          schema        :table-id  table-id))
             (column-instance (get-column-instance-by-table schema table  :column-id column-id)))
        (assert-path-object schema)
        (assert-path-object table)
        (assert-path-object column-instance)
        (assert-authority graph schema modeler :owner :writer)
        (render-json (save-column-instance-logical-name schema column-instance logical-name))))))


(defroute ("/er/schemas/:schema-id/tables/:table-id/column-instances/:column-id/description" :method :POST)
    (&key schema-id table-id column-id  |contents|)
  (with-graph-modeler (graph modeler)
    (let ((schema-id   (validate schema-id  :integer :require t))
          (table-id    (validate table-id   :integer :require t))
          (column-id (validate column-id    :integer :require t))
          (description (validate |contents| :string             :url-decode t)))
      (let* ((schema          (get-schema-by-modeler        graph modeler :schema-id schema-id))
             (table           (get-table-by-schema          schema        :table-id  table-id))
             (column-instance (get-column-instance-by-table schema table  :column-id column-id)))
        (assert-path-object schema)
        (assert-path-object table)
        (assert-path-object column-instance)
        (assert-authority graph schema modeler :owner :writer)
        (render-json (save-column-instance-description schema column-instance description))))))


;;;;;;;;
;;;;;;;; TER
;;;;;;;;
(defroute "/ter/campuses/:campus-id/environments" (&key campus-id)
  (with-graph-modeler (graph modeler)
    (let ((campus-id (validate campus-id :integer :require t)))
      (let ((campus (get-campus-by-modeler graph modeler :campus-id campus-id)))
        (assert-path-object campus)
        (assert-authority graph campus modeler :owner :writer :reader)
        (render-json (ter-environment-at-modeler-system-campus graph modeler campus))))))


(defroute ("/ter/campuses/:campus-id/cameras/:camera-id/look-at" :method :post)
    (&key campus-id camera-id |x| |y|)
  (with-graph-modeler (graph modeler)
    (let ((campus-id (validate campus-id :integer :require t))
          (camera-id (validate camera-id :integer :require t))
          (x         (validate |x|       :float   :require t))
          (y         (validate |y|       :float   :require t)))
      (let* ((campus (get-campus-by-modeler graph modeler :campus-id campus-id))
             (camera (get-camera-by-campus  graph campus  :camera-id camera-id)))
        (assert-path-object campus)
        (assert-path-object camera)
        (assert-authority graph campus modeler :owner :writer :reader)
        (render-json (save-ter-camera-look-at camera x y
                                              :graph   graph
                                              :modeler modeler))))))


(defroute ("/ter/campuses/:campus-id/cameras/:camera-id/magnification" :method :post)
    (&key campus-id camera-id |magnification|)
  (with-graph-modeler (graph modeler)
    (let ((campus-id     (validate campus-id       :integer :require t))
          (camera-id     (validate camera-id       :integer :require t))
          (magnification (validate |magnification| :float   :require t)))
      (let* ((campus (get-campus-by-modeler graph modeler :campus-id campus-id))
             (camera (get-camera-by-campus  graph campus  :camera-id camera-id)))
        (assert-path-object campus)
        (assert-path-object camera)
        (assert-authority graph campus modeler :owner :writer :reader)
        (render-json (save-ter-camera-magnification camera magnification
                                                    :graph   graph
                                                    :modeler modeler))))))


;;;
;;; entity
;;;
(defroute "/ter/campuses/:campus-id/entities" (&key campus-id)
  (with-graph-modeler (graph modeler)
    (let ((campus-id (validate campus-id :integer :require t)))
      (let ((campus (get-campus-by-modeler graph modeler :campus-id campus-id)))
        (assert-path-object campus)
        (assert-authority graph campus modeler :owner :writer :reader)
        (render-json (find-entities campus))))))


(defroute ("/systems/:sytem-id/campuses/:campus-id/graph/save" :method :post)
    (&key sytem-id campus-id)
  (with-graph-modeler (graph modeler)
    (let ((system-id (validate sytem-id  :integer :require t))
          (campus-id (validate campus-id :integer :require t)))
      (let ((system (ter::get-system graph :%id system-id)))
        (unless system (throw-code 404))
        (let ((campus (get-campus-by-system-and-modeler graph system modeler :campus-id campus-id)))
          (unless campus (throw-code 404))
          (snapshot-campus-graph campus)
          (render-json :null))))))


(defroute ("/systems/:sytem-id/campuses/:campus-id/entities" :method :post)
    (&key sytem-id campus-id |type| |code| |name| |description|)
  (with-graph-modeler (graph modeler)
    (let ((system-id   (validate sytem-id      :integer :require t))
          (campus-id   (validate campus-id     :integer :require t))
          (type        (validate |type|        :string  :require t   :url-decode t))
          (code        (validate |code|        :string  :require t   :url-decode t))
          (name        (validate |name|        :string  :require t   :url-decode t))
          (description (validate |description| :string  :require nil :url-decode t :default-value "")))
      (let ((system (ter::get-system graph :%id system-id)))
        (unless system (throw-code 404))
        (let ((campus (get-campus-by-system-and-modeler graph system modeler :campus-id campus-id)))
          (unless campus (throw-code 404))
          (render-json (ter.api.controller:create-entity campus
                                                         :type type
                                                         :code code
                                                         :name name
                                                         :description description)))))))


(defroute ("/ter/campuses/:campus-id/entities/:entity-id/location" :method :post)
    (&key campus-id entity-id |x| |y| |z|)
  (with-graph-modeler (graph modeler)
    (let ((campus-id (validate campus-id :integer :require t))
          (entity-id (validate entity-id :integer :require t))
          (x         (validate |x|       :float   :require t))
          (y         (validate |y|       :float   :require t))
          (z         (validate |z|       :float   :require t)))
      (let* ((campus (get-campus-by-modeler graph modeler :campus-id campus-id))
             (entity (get-entity-by-campus  campus        :entity-id entity-id)))
        (assert-path-object campus)
        (assert-path-object entity)
        (assert-authority graph campus modeler :owner :writer)
        (render-json (save-entity-position campus entity x y z))))))

;;;
;;; identifiers
;;;
(defroute "/ter/campuses/:campus-id/identifiers" (&key campus-id)
  (with-graph-modeler (graph modeler)
    (let ((campus-id (validate campus-id :integer :require t)))
      (let ((campus (get-campus-by-modeler graph modeler :campus-id campus-id)))
        (assert-path-object campus)
        (assert-authority graph campus modeler :owner :writer :reader)
        (render-json (find-identifier-instances campus))))))


;;;
;;; attributes
;;;
(defroute "/ter/campuses/:campus-id/attributes" (&key campus-id)
  (with-graph-modeler (graph modeler)
    (let ((campus-id (validate campus-id :integer :require t)))
      (let ((campus (get-campus-by-modeler graph modeler :campus-id campus-id)))
        (assert-path-object campus)
        (assert-authority graph campus modeler :owner :writer :reader)
        (render-json (find-attributes-instances campus))))))


;;;
;;; ports
;;;
(defroute "/ter/campuses/:campus-id/ports" (&key campus-id)
  (with-graph-modeler (graph modeler)
    (let ((campus-id (validate campus-id :integer :require t)))
      (let ((campus (get-campus-by-modeler graph modeler :campus-id campus-id)))
        (assert-path-object campus)
        (assert-authority graph campus modeler :owner :writer :reader)
        (render-json (find-entities-ports campus))))))


(defroute ("/ter/campuses/:campus-id/ports/:port-id/location" :method :post) (&key campus-id port-id |degree|)
  (with-graph-modeler (graph modeler)
    (let ((campus-id (validate campus-id :integer :require t))
          (degree    (validate |degree|  :float   :require t)))
      (let ((campus (get-campus-by-modeler graph modeler :campus-id campus-id)))
        (assert-path-object campus)
        (assert-authority graph campus modeler :owner :writer)
        (render-json (save-port-ter-location campus
                                             (parse-integer port-id)
                                             degree))))))

;;;
;;; edges
;;;
(defroute "/ter/campuses/:campus-id/edges" (&key campus-id)
  (with-graph-modeler (graph modeler)
    (let ((campus-id (validate campus-id :integer :require t)))
      (let ((campus (get-campus-by-modeler graph modeler :campus-id campus-id)))
        (assert-path-object campus)
        (assert-authority graph campus modeler :owner :writer :reader)
        (render-json (find-edge-ters campus))))))


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
    (assert-force graph modeler :grand-master)
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
