(in-package :ter)

;;  ( :code :comparative     :from 'RESOURCE', :to 'RESOURCE' ) ;; name: '対照表',
;;  ( :code :recursion       :from 'RESOURCE', :to 'RESOURCE' ) ;; name: '再帰',
;;  ( :code :resource-subset :from 'RESOURCE', :to 'RESOURCE' ) ;; name: 'サブセット',
;;  ( :code :inject          :from 'RESOURCE', :to 'EVENT' )    ;; name: 'イベント',
;;  ( :code :correspondence  :from 'EVENT',    :to 'EVENT' )    ;; name: '対応表',
;;  ( :code :inject          :from 'EVENT',    :to 'EVENT' )    ;; name: 'ヘッダ-明細',
;;  ( :code :event-subset    :from 'EVENT',    :to 'EVENT' )    ;; name: 'サブセット',
;;  ( :code :comparative     :from 'EVENT',    :to 'RESOURCE' ) ;; name: '対照表',

(defgeneric validate-relationship-type (from to type)
  (:method ((from resource) (to resource) (type symbol))
    (cond ((eq type :comparative) ;; 対照表
           (/= (up:%id from) (up:%id to))) ;; TODO: サブセットとのチェックもしよう。別の場所のほうがいいかな。。。
          ((eq type :recursion) ;; 再帰
           (= (up:%id from) (up:%id to)))
          ((eq type :resource-subset) ;; サブセット  ;;TODO: これ必要？
           t)))

  (:method ((from resource) (to event) (type symbol))
    (cond ((eq type :inject) ;; to イベント
           t)))

  (:method ((from event) (to event) (type symbol))
    (cond ((eq type :correspondence) ;; 対応表
           (/= (up:%id from) (up:%id to)))
          ((eq type :inject) ;; ヘッダ-明細
           (/= (up:%id from) (up:%id to)))
          ((eq type :event-subset) ;; サブセット  ;;TODO: これ必要？
           t)))

  (:method ((from event) (to resource) (type symbol))
    (cond ((eq type :comparative) ;; 対照表
           t))))
