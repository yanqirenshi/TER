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
           #:save-column-instance-description)
  (:export #:find-ter ;; TODO: こらはもういらんやろ。
           #:find-entities
           #:find-identifier-instances
           #:find-identifier-attributes
           #:find-edge-ters)
  (:export #:find-graph))
(in-package :ter.api.controller)
