(in-package :ter)

(defclass point ()
  ((x :accessor x :initarg :x :initform 0)
   (y :accessor y :initarg :y :initform 0)
   (z :accessor z :initarg :z :initform 0)))

(defclass rect ()
  ((w :accessor w :initarg :w :initform 333)
   (h :accessor h :initarg :h :initform 222)))

(defclass rsc ()
  ((code :accessor code :initarg :code :initform nil)
   (name :accessor name :initarg :name :initform nil)
   (description :accessor description :initarg :description :initform nil)))

(defclass port ()
  ((degree :accessor degree :initarg :degree :initform 0)))
