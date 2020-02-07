(in-package :cl-user)
(defpackage ter.api.controller
  (:nicknames :ter.api.ctrl)
  (:use #:cl)
  (:import-from :alexandria
                #:when-let)
  (:export #:assert-authority
           #:assert-force)
  (:export #:set-active-system
           #:get-schema-by-modeler
           #:get-camera-by-schema
           #:get-campus-by-modeler
           #:get-camera-by-campus
           #:get-campus-by-system-and-modeler)
  (:export #:get-table-by-schema
           #:get-column-instance-by-table
           #:finder-er-tables
           #:finder-er-columns
           #:finder-er-column-instances
           #:finder-er-relashonships
           #:find-er
           #:save-er-position
           #:save-er-size
           #:find-er-vertexes
           #:find-er-edges
           #:save-table-description
           #:save-column-instance-logical-name
           #:save-column-instance-description
           #:save-er-camera-look-at
           #:save-er-camera-magnification
           #:er-environment-at-modeler-schema)
  (:export #:find-ter ;; TODO: こらはもういらんやろ。
           #:find-entities
           #:get-entity
           #:get-entity-by-campus
           #:find-identifier-instances
           #:find-attributes-instances
           #:find-edge-ters
           #:save-entity-position
           #:find-entities-ports
           #:save-port-ter-location
           #:save-ter-camera-look-at
           #:save-ter-camera-magnification
           #:ter-environment-at-modeler-system-campus)
  (:export #:create-system
           #:create-entity)
  (:export #:find-graph)
  (:export #:pages-basic
           #:pages-systems
           #:pages-system
           #:pages-modelers))
(in-package :ter.api.controller)
