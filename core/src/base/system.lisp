(in-package :ter)

(defun eq-%id (a b)
  (format t "~S~%" (list a b))
  (eq (up:%id a) (up:%id b)))

(defun find-systems (graph &key modeler)
  (if modeler
      (mapcar #'(lambda (r)
                  (getf r :vertex))
              (ter::find-r-modeler2system-grant graph modeler))
      (shinra:find-vertex graph 'system)))

(defun get-system (graph &key code %id)
  (let ((class-symbol 'system))
    (cond (%id
           (shinra:get-vertex-at graph class-symbol :%id %id))
          (code
           (car (shinra:find-vertex graph class-symbol
                                    :slot  'code
                                    :value code))))))


(defvar *max-owner-system-count* 3)

(defun assert-max-owner-system-count (graph modeler)
  ;; TODO: ここは Forth 毎にわける必要がある。
  (assert (> *max-owner-system-count*
             (length (find-r-modeler2system-grant graph modeler :authority :owner)))))


(defun tx-make-system (graph code &key name description modeler)
  (assert (keywordp code))
  (assert modeler)
  (assert-max-owner-system-count graph modeler)
  (or (progn (warn "SYSTEM: CDOE=~a は既に存在していたので作成しませんでした。" code)
             (get-system graph :code code))
      (shinra:tx-make-vertex graph 'system
                             `((code ,code)
                               (name ,name)
                               (description ,description)))))
