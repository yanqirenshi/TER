(in-package :ter)

(defclass resource (entity) ())

(defmethod jojo:%to-json ((obj resource))
  (jojo:with-object
    (jojo:write-key-value "_id"         (slot-value obj 'up:%id))
    (jojo:write-key-value "code"        (slot-value obj 'code))
    (jojo:write-key-value "name"        (slot-value obj 'name))
    (jojo:write-key-value "description" (slot-value obj 'description))
    (jojo:write-key-value "position"    (slot-value obj 'location))
    (jojo:write-key-value "size"        (slot-value obj 'size))
    (jojo:write-key-value "_class"   "RESOURCE")))

(defclass resource-subset (resource) ())

(defmethod jojo:%to-json ((obj resource-subset))
  (jojo:with-object
    (jojo:write-key-value "_id"         (slot-value obj 'up:%id))
    (jojo:write-key-value "code"        (slot-value obj 'code))
    (jojo:write-key-value "name"        (slot-value obj 'name))
    (jojo:write-key-value "description" (slot-value obj 'description))
    (jojo:write-key-value "position"    (slot-value obj 'location))
    (jojo:write-key-value "size"        (slot-value obj 'size))
    (jojo:write-key-value "_class"   "RESOURCE-SUBSET")))
