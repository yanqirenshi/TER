<page-usage_tab-add-entity-basic>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">概要</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p></p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">Entity の追加</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p>Entity を追加するには Identifier を追加する必要があります。</p>
                <p><code>tx-build-identifier</code> を実行すると、Identifier が追加れ、Entitiy も追加されます。</p>
                <p><pre>(let ((graph (get-campus-graph (get-campus ter.db:*graph* :code "MANAGEMENT"))))
  (mapcar #'(lambda (data)
              (tx-build-identifier graph
                                   (getf data :type)
                                   (getf data :code)
                                   (getf data :name)))
          '((:type :rs :code :company                          :name "会社")
            (:type :rs :code :project                          :name "プロジェクト")
            (:type :rs :code :proposition                      :name "案件")
            (:type :rs :code :resource                         :name "リソース")
            (:type :rs :code :duty                             :name "職責")
            (:type :rs :code :manage-order-proposition-item    :name "案件の発注管理項目")
            (:type :rs :code :manage-plan-proposition-item     :name "案件の予定管理項目")
            (:type :rs :code :manage-resource-proposition-item :name "案件のリソース管理項目")
            (:type :ev :code :assign-project                   :name "プロジェクトへの担当者割当")
            (:type :ev :code :assign-proposition               :name "案件への担当者割当")
            (:type :ev :code :manage-order-proposition         :name "案件の発注管理")
            (:type :ev :code :manage-order-proposition-dtl     :name "案件の発注管理明細")
            (:type :ev :code :manage-plan-proposition          :name "案件の予定管理")
            (:type :ev :code :manage-plan-proposition-dtl      :name "案件の予定管理明細")
            (:type :ev :code :manage-resouce-proposition       :name "案件のリソース管理")
            (:type :ev :code :manage-resouce-proposition-dtl   :name "案件のリソース管理明細")
            (:type :ev :code :proposition-estimate             :name "案件の見積")
            (:type :ev :code :proposition-estimate-dtl         :name "案件の見積明細")
            (:type :ev :code :resource-estimate                :name "リソースの見積"))))</pre></p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">対照表/対応表の追加</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p>tx-make-relationship</p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">Identifier を持たないエンティティの追加</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p>未実装。。。。</p>
            </div>
        </div>
    </section>

</page-usage_tab-add-entity-basic>
