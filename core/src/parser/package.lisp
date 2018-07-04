(defpackage ter.parser
  (:use #:cl)
  (:import-from :alexandria
                #:when-let)
  (:import-from :cl-lex
                #:define-string-lexer
                #:stream-lexer)
  (:import-from :yacc
                #:define-parser
                #:parse-with-lexer)
  (:export #:parse-schema.rb))
(in-package :ter.parser)

(defun get-value-string (value)
  (multiple-value-bind (ret arr)
      (cl-ppcre:scan-to-strings  "^\"(.*)\"$" (string-trim '(#\Space #\Tab #\Newline) value))
    (unless ret (warn "~S がパース出来ませんでした。" value))
    (if ret (aref arr 0) nil)))

(defun str2keyword (str)
  (alexandria:make-keyword (string-upcase str)))
