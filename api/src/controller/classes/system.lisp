(in-package :ter.api.controller)

(defclass system ()
  ((%id         :accessor %id         :initarg :%id         :initform nil)
   (code        :accessor code        :initarg :code        :initform nil)
   (name        :accessor name        :initarg :name        :initform nil)
   (description :accessor description :initarg :description :initform nil)
   (campuses    :accessor campuses    :initarg :campuses    :initform nil)
   (schemas     :accessor schemas     :initarg :schemas     :initform nil)
   (authority   :accessor authority   :initarg :authority   :initform nil)))


(defmethod jojo:%to-json ((obj system))
  (jojo:with-object
    (jojo:write-key-value "_id"             (slot-value obj '%id))
    (jojo:write-key-value "code"            (slot-value obj 'code))
    (jojo:write-key-value "name"            (slot-value obj 'name))
    (jojo:write-key-value "description"     (or (slot-value obj 'description) ""))
    (jojo:write-key-value "campuses"        (or (slot-value obj 'campuses) nil))
    (jojo:write-key-value "schemas"         (or (slot-value obj 'schemas) nil))
    (jojo:write-key-value "authority"       (or (slot-value obj 'authority) nil))
    (jojo:write-key-value "_class"          "SYSTEM")))


(defun system2system (graph system &key modeler)
  (let ((new-system (make-instance 'system)))
    (setf (%id new-system)         (up:%id system))
    (setf (name new-system)        (ter::name system))
    (setf (code new-system)        (ter::code system))
    (setf (description new-system) (ter::description system))
    (setf (campuses new-system)
          (ter:find-campus graph :system system))
    (setf (schemas new-system)
          (ter:find-schema graph :system system))
    (when modeler
      (let ((r (ter::get-r-modeler2system-grant graph modeler :system system)))
        (let ((edge (getf r :edge)))
          (setf (authority new-system) (ter::authority edge)))))
    new-system))
