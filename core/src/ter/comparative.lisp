(in-package :ter)

(defun find-comparative (graph)
  (shinra:find-vertex graph 'comparative))


(defun get-comparative (graph &key code)
  (car (shinra:find-vertex graph 'comparative :slot 'code :value code)))


(defun tx-make-comparative-add-identifier (graph entity original)
  (when original
    (tx-add-identifier-instance graph entity
                                (list :code (code original)
                                      :name (name original)
                                      :data-type (data-type original))
                                :type :foreigner)))


(defun tx-make-comparative (graph code name &key from to)
  (when (get-comparative graph :code code)
    (error "Aledy exist entity. code=~S" code))
  (let ((comparative (tx-make-vertex graph
                                     'comparative
                                     `((code ,code)
                                       (name ,name))))
        ;; わざわざ rename 。
        (original-from-identifier from)
        (original-to-identifier   to))
    (values comparative
            (tx-make-comparative-add-identifier graph comparative original-from-identifier)
            (tx-make-comparative-add-identifier graph comparative original-to-identifier))))
