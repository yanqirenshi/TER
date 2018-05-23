(in-package :ter.parser)

(defun parse-arr-key (_lp _rp)
  (declare (ignore _lp _rp))
  (list :array))

(defun parse-arr-contents (_lp sequence _rp)
  (declare (ignore _lp _rp))
  sequence)

(defun parse-sequence (json _c sequence)
  (declare (ignore _c))
  (if (listp sequence)
      (cons json sequence)
      (list json sequence)))

(defun parse-member (string _c json)
  (declare (ignore _c))
  (cons string json))

(defun parse-members (member _c members)
  (declare (ignore _c))
  (if (listp (car members))
      (cons member members)
      (list member members)))

(defun parse-object-key (_lp _rp)
  (declare (ignore _lp _rp))
  (list :obj))

(defun parse-object-contents (_lp members _rp)
  (declare (ignore _lp _rp))
  (cons :obj members))
