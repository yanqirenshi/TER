<core_page_tab_usage>

    <section class="section">
        <div class="container">
            <h1 class="title is-5">Entity を追加する。</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <pre><code></code></pre>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-5">Entity へ Identifier を追加する。</h1>
            <h2 class="subtitle"></h2>


            <section class="section">
                <div class="container">
                    <h1 class="title is-6">Naive な Identifier の追加</h1>
                    <h2 class="subtitle"></h2>

                    <div class="contents">
                        <div class="contents">
                            <pre><code>(tx-add-identifier-2-entity ter.db:*graph*
                            :campus-code :rbp
                            :entity-code :user
                            :code        :image
                            :name        "更新日時 (エンドユーザー)"
                            :data-type   "datetime")</code></pre>
                        </div>
                    </div>
                </div>
            </section>

            <section class="section">
                <div class="container">
                    <h1 class="title is-6">Foreigner な Identifier の追加</h1>
                    <h2 class="subtitle"></h2>

                    <div class="contents">
                        <div class="contents">
                            <pre><code>(tx-add-identifier-2-entity ter.db:*graph*
                            :campus-code :rbp
                            :entity-code :user
                            :code        :image
                            :name        "更新日時 (エンドユーザー)"
                            :data-type   "datetime"
                            :type        :foreigner)</code></pre>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-5">Entity へ Attribute を追加する。</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <pre><code>(tx-add-attribute-2-entity ter.db:*graph*
                           :campus-code :rbp
                           :entity-code :user
                           :code        :image
                           :name        "更新日時 (エンドユーザー)"
                           :data-type   "datetime")</code></pre>
            </div>
        </div>
    </section>

</core_page_tab_usage>
