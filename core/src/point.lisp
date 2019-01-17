(in-package :ter)

(defgeneric save-position (graph obj x y z)
  (:method (graph (obj point) (x number) (y number) (z number))
    (let ((class (class-name (class-of obj))))
      (up:execute-transaction
       (up:tx-change-object-slots graph class (up:%id obj)
                                  `((x ,x)
                                    (y ,y)
                                    (z ,z))))
      obj)))

(defgeneric save-size (graph obj w h)
  (:method (graph (obj point) (w number) (h number))
    (let ((class (class-name (class-of obj))))
      (up:execute-transaction
       (up:tx-change-object-slots graph class (up:%id obj)
                                  `((w ,w)
                                    (h ,h))))
      obj)))
