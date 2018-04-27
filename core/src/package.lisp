(defpackage ter
  (:use #:cl
        #:ter.db)
  (:import-from :alexandria
                #:when-let)
  (:import-from :shinra
                #:find-vertex
                #:tx-make-vertex
                #:tx-make-edge))
(in-package :ter)
