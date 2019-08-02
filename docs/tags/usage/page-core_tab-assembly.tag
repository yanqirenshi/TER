<page-core_tab-assembly>

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
            <h1 class="title is-4">System - Schema</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p><pre>(let* ((graph ter.db:*graph*)
       (system (get-system graph :code :my-system))
       (schema (get-schema graph :code :my-system)))
  (up:execute-transaction
   (tx-make-edge-system2schema graph system schema)))</pre></p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">System - Campus</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p>これがほんとうなのかな？ schema - campus じゃないかな。。。。。</p>
                <p><pre>(let* ((graph ter.db:*graph*)
       (system (get-system graph :code :my-system))
       (campus (get-campus graph :code :my-system)))
  (up:execute-transaction
   (tx-make-edge-system2campus graph system campus)))</pre></p>
            </div>
        </div>
    </section>

</page-core_tab-assembly>
