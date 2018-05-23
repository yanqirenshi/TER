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

(define-parser json-parser
  (:start-symbol json)
  (:terminals ({ } [ ] |:| |,| |'| string number true false null))
  (json object array string number true false null)
  (object         ({ }                #'ter.parser::parse-object-key)
                  ({ members }        #'ter.parser::parse-object-contents))
  (array          ([ ]                #'ter.parser::parse-arr-key)
                  ([ sequence ]       #'ter.parser::parse-arr-contents))
  (sequence json  (json |,| sequence  #'ter.parser::parse-sequence))
  (member         (string |:| json    #'ter.parser::parse-member))
  (members member (member |,| members #'ter.parser::parse-members)))

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
