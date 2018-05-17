(in-package :ter.parser)

;;;;;
;;;;; Refer:
;;;;;   http://tanakahx.hatenablog.com/entry/2015/08/20/235933
;;;;;

(define-string-lexer json-lexer
  ("{"                                              (return (values '{      $@)))
  ("}"                                              (return (values '}      $@)))
  ("\\["                                            (return (values '[      '[)))
  ("\\]"                                            (return (values ']      '])))
  (":"                                              (return (values '|:|    '|:|)))
  (","                                              (return (values '|,|    '|,|)))
  ("'"                                              (return (values '|'|    '|'|)))
  ("\"([^\\\"]|\\.)*?\""                            (return (values 'string (string-trim "\"" $@))))
  ("-?0|[1-9][0-9]*(\\.[0-9]*)?([e|E][+-]?[0-9]+)?" (return (values 'number (read-from-string $@))))
  ("true"                                           (return (values 'true   'true)))
  ("false"                                          (return (values 'false  'false)))
  ("null"                                           (return (values 'null    'null))))

(defun parse-arr-key (_lp _rp)
  (declare (ignore _lp _rp))
  (list :array))

(defun parse-arr-contents (_lp sequence _rp)
  (declare (ignore _lp _rp))
  sequence)

(defun parse-sequence (json _c sequence)
  (declare (ignore _c))
  (if (listp sequence)
      (cons json sequence)
      (list json sequence)))

(defun parse-member (string _c json)
  (declare (ignore _c))
  (cons string json))

(defun parse-members (member _c members)
  (declare (ignore _c))
  (if (listp (car members))
      (cons member members)
      (list member members)))

(defun parse-object-key (_lp _rp)
  (declare (ignore _lp _rp))
  (list :obj))

(defun pase-object-contents (_lp members _rp)
  (declare (ignore _lp _rp))
  (cons :obj members))

(define-parser json-parser
  (:start-symbol json)
  (:terminals ({ } [ ] |:| |,| |'| string number true false null))
  (json object array string number true false null)
  (object         ({ }                #'parse-object-key)
                  ({ members }        #'pase-object-contents))
  (array          ([ ]                #'parse-arr)
                  ([ sequence ]       #'parse-arr-contents))
  (sequence json  (json |,| sequence  #'parse-sequence))
  (member         (string |:| json    #'parse-member))
  (members member (member |,| members #'parse-members)))

(defun test-json-1 ()
  (parse-with-lexer (json-lexer
                     "{\"foo\":\"bar\",\"baz\":\"bang\",\"bing\":100,\"bingo\":1.1,\"bazo\": [1,2,\"foo\"]}")
                    json-parser))

(defun test-json-2 (pathname)
  (with-open-file (*standard-input* pathname)
    (parse-with-lexer (stream-lexer #'read-line
                                    #'json-lexer
                                    #'(lambda (c) (declare (ignore c)))
                                    #'(lambda (c) (declare (ignore c))))
                      json-parser)))
