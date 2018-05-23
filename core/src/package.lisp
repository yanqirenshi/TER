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
  (:export #:find-entitiy
           #:find-attribute
           #:find-attribute-entity
           #:find-all-edges))
(in-package :ter)
