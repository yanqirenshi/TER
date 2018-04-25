#|
  This file is a part of ter project.
|#

(defsystem "ter-test"
  :defsystem-depends-on ("prove-asdf")
  :author ""
  :license ""
  :depends-on ("ter"
               "prove")
  :components ((:module "tests"
                :components
                ((:test-file "ter"))))
  :description "Test system for ter"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
