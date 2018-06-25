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
                 (:module "class" :components ((:file "common")
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
                                                                           (:file "resource")
                                                                           (:file "event")
                                                                           (:file "comparative")
                                                                           (:file "correspondence")
                                                                           (:file "recursion")
                                                                           (:file "edge-ter")
                                                                           (:file "port-ter")))
                                               (:file "mapper")))
                 (:file "point")
                 ;; base
                 (:module "base" :components ((:file "schema")
                                              (:file "drawing")
                                              (:file "camera")
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
                                             (:file "port")
                                             (:file "relationship-common")
                                             (:file "relationship-rsc2rsc")
                                             (:file "relationship-rsc2evt")
                                             (:file "relationship-evt2evt")
                                             (:file "relationship")))
                 (:file "mapper")
                 (:module "importer" :components ((:file "schema.rb"))))))
  :description ""
  :long-description #.(read-file-string
                       (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "ter-test"))))
