#|
This file is a part of ter project.
|#

(defsystem "ter"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (#:cl-lex
               #:yacc
               #:cl-inflector
               #:jonathan
               #:sephirothic
               #:upanishad
               #:shinrabanshou
               #:plist-printer
               #:parser.schema.rb)
  :components ((:module "src"
                :components
                ((:file "db")
                 (:module "parser" :components ((:file "package")
                                                (:file "json-items")
                                                (:file "json")
                                                (:file "ruby")
                                                (:file "ruby-unrefined")))
                 (:file "package")
                 (:module "classes"
                  :components ((:file "common")
                               (:file "edge")
                               (:module "base" :components ((:file "drawing")
                                                            (:file "schema")
                                                            (:file "camera")))
                               (:module "er" :components ((:file "column")
                                                          (:file "table")
                                                          (:file "edge-er")
                                                          (:file "port-er")))
                               (:module "ter" :components ((:file "campus")
                                                           (:file "identifier")
                                                           (:file "attribute")
                                                           (:file "entity")
                                                           (:file "resource")
                                                           (:file "event")
                                                           (:file "comparative")
                                                           (:file "correspondence")
                                                           (:file "recursion")
                                                           (:file "edge-ter")
                                                           (:file "port-ter")))
                               (:file "mapper")
                               (:file "modeler")))
                 (:file "config")
                 (:file "point")
                 (:module "modeler"
                  :components ((:file "ghost-shadow")
                               (:file "ghost-shadow-to-modeler")
                               (:file "modeler")))
                 ;; base
                 (:module "base" :components ((:file "schema")
                                              (:file "drawing")
                                              (:file "camera")
                                              (:file "campus")
                                              (:file "common")))
                 ;; er
                 (:module "er" :components ((:file "column")
                                            (:file "column-instance")
                                            (:file "table")
                                            (:file "port")
                                            (:file "relationship")
                                            (:file "er")))
                 ;; ter
                 (:module "ter" :components ((:file "identifier")
                                             (:file "identifier-instance")
                                             (:file "attribute")
                                             (:file "attribute-instance")
                                             (:file "resource")
                                             (:file "event")
                                             (:file "comparative")
                                             (:file "correspondence")
                                             (:file "recursion")
                                             (:file "port-ter")
                                             (:file "edge-ter")
                                             (:file "build-entity-contents")
                                             (:file "relationship-common")
                                             (:file "relationship-rsc2rsc")
                                             (:file "relationship-rsc2evt")
                                             (:file "relationship-evt2evt")
                                             (:file "relationship")))
                 (:file "mapper")
                 (:module "importer" :components ((:module "schema.rb" :components ((:file "util")
                                                                                    (:file "foreign-key")
                                                                                    (:file "table")
                                                                                    (:file "main"))))))))
  :description ""
  :long-description #.(read-file-string
                       (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "ter-test"))))
