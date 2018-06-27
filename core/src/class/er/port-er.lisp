(in-package :ter)

(defclass port-er (shinra:shin rsc port) ())

(defmethod jojo:%to-json ((obj port-er))
  (jojo:with-object
    (jojo:write-key-value "_id"    (slot-value obj 'up:%id))
    (jojo:write-key-value "degree" (slot-value obj 'degree))
    (jojo:write-key-value "_class" "port-er")))

(defclass port-er-in (port-er) ())

(defmethod jojo:%to-json ((obj port-er-in))
  (jojo:with-object
    (jojo:write-key-value "_id"    (slot-value obj 'up:%id))
    (jojo:write-key-value "degree" (slot-value obj 'degree))
    (jojo:write-key-value "_class" "PORT-ER-IN")))

(defclass port-er-out (port-er) ())

(defmethod jojo:%to-json ((obj port-er-out))
  (jojo:with-object
    (jojo:write-key-value "_id"    (slot-value obj 'up:%id))
    (jojo:write-key-value "degree" (slot-value obj 'degree))
    (jojo:write-key-value "_class" "PORT-ER-OUT")))
