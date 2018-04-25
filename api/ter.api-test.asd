#|
  This file is a part of ter.api project.
|#

(defsystem "ter.api-test"
  :defsystem-depends-on ("prove-asdf")
  :author ""
  :license ""
  :depends-on ("ter.api"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "ter.api"))))
  :description "Test system for ter.api"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
