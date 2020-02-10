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
                               (:module "base" :components ((:file "common")
                                                            (:file "system")
                                                            (:file "force")
                                                            (:file "schema")
                                                            (:file "camera")
                                                            (:file "campus")))
                               (:module "er" :components ((:file "column")
                                                          (:file "table")
                                                          (:file "edge-er")
                                                          (:file "port-er")))
                               (:module "ter" :components ((:file "identifier")
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
                 ;; base
                 (:module "base" :components ((:file "schema")
                                              (:file "drawing")
                                              (:file "camera")
                                              (:file "campus")
                                              (:file "force")
                                              (:file "system")
                                              (:file "ghost-shadow")
                                              (:file "modeler")
                                              (:file "ghost-shadow_modeler")
                                              (:file "modeler2system_grant")
                                              (:file "modeler2system_select")
                                              (:file "system2schema")
                                              (:file "system2campus")
                                              (:file "force2modeler")
                                              (:file "relationship2camera")
                                              (:file "base")))
                 ;; er
                 (:module "er" :components ((:file "column")
                                            (:file "column-instance")
                                            (:file "table")
                                            (:file "port")
                                            (:file "relationship")
                                            (:file "er")))
                 ;; ter
                 (:module "ter" :components ((:file "predicates")
                                             (:file "identifier")
                                             (:file "identifier-instance")
                                             (:file "attribute")
                                             (:file "attribute-instance")
                                             (:file "resource")
                                             (:file "event")
                                             (:file "comparative")
                                             (:file "correspondence")
                                             (:file "recursion")
                                             (:file "entity")
                                             (:file "port-ter")
                                             (:file "edge-ter")
                                             (:module "relationship"
                                              :components ((:file "entity")
                                                           (:file "entity-identifier")
                                                           (:file "entity-attribute")
                                                           (:file "entity-port")
                                                           (:file "id2id-instance")
                                                           (:file "attr2attr-instance")
                                                           ;; entity 2 entity
                                                           (:file "relationship-type")
                                                           (:file "comparative")
                                                           (:file "correspondence")
                                                           (:file "inject")
                                                           (:file "recursion")
                                                           (:file "subset")
                                                           (:file "entity2entity")
                                                           (:file "relationship")))
                                             (:file "user-operators")))
                 (:file "mapper")
                 (:module "importer" :components ((:module "schema.rb" :components ((:file "util")
                                                                                    (:file "foreign-key")
                                                                                    (:file "table")
                                                                                    (:file "main"))))))))
  :description ""
  :long-description #.(read-file-string
                       (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "ter-test"))))
