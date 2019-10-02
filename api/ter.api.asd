#|
  This file is a part of ter.api project.
|#

(defsystem "ter.api"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ("caveman2" "ter" "lack-middleware-validation")
  :components ((:module "src"
                :components
                ((:file "package")
                 (:module "controller"
                  :components ((:file "package")
                               (:module "classes"
                                :components ((:file "modeler")
                                             (:file "system")
                                             (:file "campus")
                                             (:file "schema")))
                               (:file "base")
                               (:file "environment")
                               (:file "er")
                               (:file "ter")
                               (:file "graph")
                               (:file "common")
                               (:file "session")))
                 (:file "utilities")
                 (:file "render")
                 (:file "router"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "ter.api-test"))))
