(in-package :ter)


(defgeneric tx-make-fk (graph table-from column-from table-to column-to)
  (:method (graph
            (table-from symbol) (column-from symbol)
            (table-to   symbol) (column-to   symbol))
    (tx-make-fk graph
                (get-table graph :code table-from) column-from
                (get-table graph :code table-to)   column-to))
  (:method (graph
            (table-from table) (column-from symbol)
            (table-to   table) (column-to   symbol))
    (tx-make-fk graph
                table-from
                (get-table-column-instance graph
                                           table-from
                                           :code column-from)
                table-to
                (get-table-column-instance graph
                                           table-to
                                           :code column-to)))
  (:method (graph
            (table-from table) (column-from column-instance)
            (table-to   table) (column-to   column-instance))
    (declare (ignore table-from table-to))
    (tx-make-r-port-er graph
                       (column-instance-port graph column-from :out)
                       (column-instance-port graph column-to   :in)))))))


;;
;; EX) tx-make-fk
;;
;; (let ((graph ter.db:*graph*))
;;   (let ((schema (ter:get-schema graph :code :ex-schema)))
;;     (let ((schema-graph (ter::get-schema-graph schema)))
;;       (tx-make-fk schema-graph
;;                   :table-a :table-a-id
;;                   :table-b :table-a-id))))
