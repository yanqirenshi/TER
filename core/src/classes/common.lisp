(in-package :ter)

;;;;;
;;;;; point
;;;;;
(defclass point ()
  ((x :accessor x :initarg :x :initform 0)
   (y :accessor y :initarg :y :initform 0)
   (z :accessor z :initarg :z :initform 0)))

(defmethod jojo:%to-json ((obj point))
  (jojo:with-object
    (jojo:write-key-value "x" (slot-value obj 'x))
    (jojo:write-key-value "y" (slot-value obj 'y))
    (jojo:write-key-value "z" (slot-value obj 'z))))


;;;;;
;;;;; rect
;;;;;
(defclass rect ()
  ((w :accessor w :initarg :w :initform 333)
   (h :accessor h :initarg :h :initform 222)))

(defmethod jojo:%to-json ((obj rect))
  (jojo:with-object
    (jojo:write-key-value "w" (slot-value obj 'w))
    (jojo:write-key-value "h" (slot-value obj 'h))))


;;;;;
;;;;; rsc
;;;;;
(defclass rsc ()
  ((code :accessor code :initarg :code :initform nil)
   (name :accessor name :initarg :name :initform nil)
   (description :accessor description :initarg :description :initform nil)))


;;;;;
;;;;; port
;;;;;
(defclass port ()
  ((degree :accessor degree :initarg :degree :initform 0)))
