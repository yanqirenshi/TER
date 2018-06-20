(in-package :ter.api.controller)

(defun save-camera-look-at (graph camera look-at)
  (up:execute-transaction
   (up:tx-change-object-slots graph 'camera (up:%id camera)
                              `((ter::look-at ,look-at))))
  camera)

(defun save-camera-magnification (graph camera magnification)
  (up:execute-transaction
   (up:tx-change-object-slots graph 'camera (up:%id camera)
                              `((ter::magnification ,magnification))))
  camera)
