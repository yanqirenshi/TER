(in-package :ter)

(defun find-port-er (graph &key (select :all))
  (cond ((eq :all select)
         (nconc (shinra:find-vertex graph 'port-er-in)
                (shinra:find-vertex graph 'port-er-out)))
        ((eq :in select) (shinra:find-vertex graph 'port-er-in))
        ((eq :out select) (shinra:find-vertex graph 'port-er-out))))

(defun get-port-er (graph &key code)
  (or (car (shinra:find-vertex graph 'port-er-in  :slot 'code :value code))
      (car (shinra:find-vertex graph 'port-er-out :slot 'code :value code))))

(defun tx-make-port-er (graph type)
  (shinra:tx-make-vertex graph (port-type2class type) '()))

(defun port-type2class (type)
  (cond ((eq :in  type) 'port-er-in)
        ((eq :out type) 'port-er-out)
        (t (error "bad type"))))

(defun %add-port-er (graph type from)
  ;; TODO: type でクラスを分ける。
  (let ((port (tx-make-port-er graph type)))
    (shinra:tx-make-edge graph 'edge-er from port :have)
    port))

(defgeneric add-port-er (graph type from)
  (:method (graph type (from column-instance))
    (%add-port-er graph type from)))
