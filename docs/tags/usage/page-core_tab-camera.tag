<page-core_tab-camera>

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
            <h1 class="title is-4">作成</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p><pre>(let ((graph ter.db:*graph*))
  (up:execute-transaction
   (tx-make-camera graph :my-system-1 :name "My System #1")))</pre></p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">一覧取得</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p><pre></pre></p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">取得</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p><pre>(let ((graph ter.db:*graph*))
  (get-camera graph :code :my-system-1))</pre></p>
            </div>
        </div>
    </section>

</page-core_tab-camera>
