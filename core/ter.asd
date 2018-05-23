#|
  This file is a part of ter project.
|#

(defsystem "ter"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (#:cl-lex
               #:yacc
               #:upanishad
               #:shinrabanshou)
  :components ((:module "src"
                :components
                ((:file "db")
                 (:module "parser" :components ((:file "package")
                                                (:file "json-items")
                                                (:file "json")
                                                (:file "ruby")
                                                (:file "ruby-unrefined")))
                 (:file "package")
                 (:module "class" :components ((:file "er")
                                               (:file "ter")))
                 ;; er
                 (:module "er" :components ((:file "column")
                                            (:file "column-instance")
                                            (:file "table")
                                            (:file "relationship")))
                 ;; ter
                 (:module "ter" :components ((:file "identifier")
                                             (:file "attribute")
                                             (:file "attribute-instance")
                                             (:file "resource")
                                             (:file "event")
                                             (:file "comparative")
                                             (:file "correspondence")
                                             (:file "recursion")))
                 (:file "mapper")
                 (:module "importer" :components ((:file "schema.rb"))))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "ter-test"))))
