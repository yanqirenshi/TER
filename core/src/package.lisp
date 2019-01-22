(defpackage ter
  (:use #:cl
        #:ter.db)
  (:import-from :alexandria
                #:when-let
                #:make-keyword)
  (:import-from :shinra
                #:find-vertex
                #:tx-make-vertex
                #:tx-make-edge)
  ;; er
  (:export #:get-schema
           #:find-table
           #:find-column
           #:find-column-instance
           #:find-er-all-edges)
  ;; ter
  (:export #:get-campus
           #:find-resource
           #:find-event
           #:find-correspondence
           #:find-comparative
           #:find-recursion
           #:find-attribute
           #:find-attribute-instance
           #:find-identifier
           #:find-identifier-instance
           #:find-ter-all-edges
           #:find-entity-identifiers
           #:find-identifier-ports
           #:find-ter-cameras)
  ;; modeler
  (:export #:tx-make-modeler-with-ghost
           #:get-modeler)
  (:export #:find-mapping-all-edges))
(in-package :ter)
