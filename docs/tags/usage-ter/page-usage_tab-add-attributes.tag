<page-usage_tab-add-attributes>

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
            <h1 class="title is-4">Entity への Attribute の追加</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p><pre>(let ((graph (get-campus-graph (get-campus ter.db:*graph* :code "MANAGEMENT"))))
  (tx-add-attributes graph
                     (get-event graph :code :resource-estimate)
                     '((:code :amount             :name "数量"           :data-type :integer)
                       (:code :unit               :name "単位"           :data-type :string)
                       (:code :valid-period-start :name "有効期間(開始)" :data-type :timestamp)
                       (:code :valid-period-end   :name "有効期間(終了)" :data-type :timestamp)
                       (:code :description        :name "備考"           :data-type :text))))</pre></p>
            </div>
        </div>
    </section>

</page-usage_tab-add-attributes>
