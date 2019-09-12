(in-package :cl-user)
(defpackage ter.api.controller
  (:use #:cl)
  (:import-from :alexandria
                #:when-let)
  (:export #:finder-er-tables
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
           #:save-er-camera-magnification)
  (:export #:find-ter ;; TODO: こらはもういらんやろ。
           #:find-entities
           #:get-entity
           #:find-identifier-instances
           #:find-attributes-instances
           #:find-edge-ters
           #:save-entity-position
           #:find-entities-ports
           #:save-port-ter-location
           #:save-ter-camera-look-at
           #:save-ter-camera-magnification)
  (:export #:create-system)
  (:export #:find-graph))
(in-package :ter.api.controller)
