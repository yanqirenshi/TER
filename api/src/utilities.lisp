(in-package :cl-user)
(defpackage ter.api.utilities
  (:use #:cl
        #:caveman2)
  (:export #:with-graph-modeler
           #:str2keyword
           #:assert-path-object
           #:get-schema
           #:get-campus
           #:get-camera))
(in-package :ter.api.utilities)


(defun assert-modeler (modeler)
  (unless modeler
    (throw-code 401)))


(defmacro with-graph-modeler ((graph modeler) &body body)
  `(let* ((,graph ter.db:*graph*)
          (,modeler (ter.api.controller::session-modeler ,graph)))
     (assert-modeler ,modeler)
     ,@body))


(defun str2keyword (str)
  (when str
    (alexandria:make-keyword (string-upcase str))))


(defgeneric get-schema (graph schema-code)
  (:method (graph (schema-code symbol))
    (or (ter::get-schema graph :code schema-code)
        (caveman2:throw-code 404)))
  (:method (graph (schema-code string))
    (get-schema graph (str2keyword schema-code))))


(defun get-campus (graph campus-code)
  (or (ter:get-campus graph :code (str2keyword campus-code))
      (throw-code 404)))


(defun get-camera (graph camera-code)
  ;; TODO: modeler との関係で見ないとね
  (or (ter::get-camera graph :code (str2keyword camera-code))
      (throw-code 404)))

(defun assert-path-object (obj)
  (unless obj (throw-code 404)))
