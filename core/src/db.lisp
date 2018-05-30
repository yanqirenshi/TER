(defpackage ter.db
  (:use :cl)
  (:import-from :asdf
                #:system-source-directory)
  (:import-from :fad
                #:list-directory)
  (:import-from :shinra
                #:banshou
                #:make-banshou)
  (:export #:*graph*
           #:start
           #:stop
           #:snapshot
           #:reboot))
(in-package :ter.db)

(defvar *graph* nil)

(defvar *graph-stor-dir*
  (merge-pathnames "../data/graph/" (system-source-directory :ter)))

(defun start ()
  (when *graph* (stop))
  (setf *graph*
        (make-banshou 'banshou *graph-stor-dir*)))

(defun snapshot ()
  (up:snapshot *graph*))

(defun stop ()
  (when *graph*
    (up:stop *graph*)
    (setf *graph* nil)))

(defun reboot ()
  (stop)
  (mapcar #'delete-file
          (fad:list-directory *graph-stor-dir*))
  (start))
