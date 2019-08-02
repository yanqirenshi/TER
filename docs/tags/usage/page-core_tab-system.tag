<page-usage_tab-system>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">準備</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p><pre>(in-package :ter)</pre></p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">System の作成</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p><pre>(up:execute-transaction
 (tx-make-system ter.db:*graph* :my-system :name "My System"))</pre></p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">System の一覧取得</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p><pre>(find-systems ter.db:*graph*)</pre></p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">System の作成</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p><pre>(get-system ter.db:*graph* :code :my-system)</pre></p>
            </div>
        </div>
    </section>

</page-usage_tab-system>
