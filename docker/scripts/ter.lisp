(in-package :cl-user)


;;;;;
;;;;; setting environments
;;;;;
;;; SBCL
(setf sb-impl::*default-external-format* :utf-8)
(setf sb-alien::*default-c-string-external-format* :utf-8)

;;; ASDF
(require "asdf")
(push #P"~/.asdf/" asdf:*central-registry*)

;;; Quicklisp
#-quicklisp
(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp"
                                       (user-homedir-pathname))))
  (when (probe-file quicklisp-init)
    (load quicklisp-init)))


;;;;;
;;;;; load libs
;;;;;
(ql:quickload :alexandria)
(ql:quickload :strobolights)
(ql:quickload :ter)
(ql:quickload :ter.api)


;;;;;
;;;;; setting strobolights
;;;;;
(setf strobolights:*additional-components*
 '((:mount "/api/v1" ter.api.router:*api-v1*)))


;;;;;
;;;;; def funcs
;;;;;
(defun server ()
  (let ((srv_str (uiop:getenv "STROBOLIGHTS_SERVER")))
    (if (null srv_str)
        :woo
        (alexandria:make-keyword (string-upcase srv_str)))))

(defun address ()
  (or (uiop:getenv "STROBOLIGHTS_ADDRESS")
      "0.0.0.0")) ;; "127.0.0.1"

(defun port ()
  (let ((port_str (uiop:getenv "STROBOLIGHTS_PORT")))
    (if port_str
        (parse-integer port_str)
        8080)))

(defun figure-8 ()
  (do ((i 0)) (nil)
    (sleep 1)
    (if (/= 88888888 i)
        (incf i)
        (progn (setf i 1)
               (sb-ext:gc)))))


;;;;;
;;;;; def main
;;;;;
(defun main (&rest argv)
  (declare (ignorable argv))
  (setf ter:*graph-stor-dir*
        (or (uiop:getenv "DIR_GRAPH_COMMON")
            "/home/appl-user/var/ter/graph/common/"))
  (setf ter:*campus-directory-root*
        (or (uiop:getenv "DIR_GRAPH_CAMPUS")
            "/home/appl-user/var/ter/graph/campus/"))
  (setf ter:*schema-directory-root*
        (or (uiop:getenv "DIR_GRAPH_SCHEMA")
            "/home/appl-user/var/ter/graph/schema/"))
  (ter.db:start)
  (format t "X=~S~%" (list (server)
                           (address)
                           (port)))
  (strobolights:start :server  (server)
                      :address (address)
                      :port    (port))
  (figure-8))


;;;;;
;;;;; start
;;;;;
(main)
