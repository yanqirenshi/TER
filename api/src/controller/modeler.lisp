(in-package :ter.api.controller)

(defclass modeler ()
  ((%id  :accessor %id  :initarg :%id  :initform nil)
   (name :accessor name :initarg :name :initform nil)))

(defmethod jojo:%to-json ((obj modeler))
  (jojo:with-object
    (jojo:write-key-value "_id"  (slot-value obj '%id))
    (jojo:write-key-value "name" (slot-value obj 'name))))

(defun modeler2modeler (modeler)
  (let ((new-campus (make-instance 'modeler)))
    (setf (%id new-campus)  (up:%id modeler))
    (setf (name new-campus) (ter::name modeler))
    new-campus))
