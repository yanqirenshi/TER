#|
  This file is a part of ter project.
|#

(defsystem "ter"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on (#:upanishad
               #:shinrabanshou)
  :components ((:module "src"
                :components
                ((:file "db")
                 ;;
                 (:file "package")
                 (:file "class")
                 (:file "attribute")
                 (:file "entity")
                 (:file "relationship")
                 (:file "schema.rb"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.markdown"))
  :in-order-to ((test-op (test-op "ter-test"))))
