(in-package :ter)

(defgeneric save-position (graph obj data)
  (:method (graph (obj point) (data list))
    (let ((class (class-name (class-of obj))))
      (up:execute-transaction
       (up:tx-change-object-slots graph class (up:%id obj)
                                  `((x ,(getf data :|x|))
                                    (y ,(getf data :|y|))
                                    (z ,(getf data :|z|)))))
      obj)))

(defgeneric save-size (graph obj w h)
  (:method (graph (obj point) (w number) (h number))
    (let ((class (class-name (class-of obj))))
      (up:execute-transaction
       (up:tx-change-object-slots graph class (up:%id obj)
                                  `((w ,w)
                                    (h ,h))))
      obj)))
