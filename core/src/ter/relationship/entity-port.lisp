(in-package :ter)

(defgeneric tx-add-port-ter (entity port-ter)
  (:method ((entity entity) (port-ter port-ter))
    (list entity port-ter)))
