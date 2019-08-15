<page-core_tab-readme>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">データの構成(基礎)</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p><pre>ghost-shadow                       +---1:n---> schema ---1:n---+
     |                             |  (have)            (have) |
    1:1      +---1:n---> system ---|                           +---> camera
     |       |  (selected)         |                           |       ^
     V       |                     `---1:n---> campus ---1:n---+       |
  modeler ---+                        (have)            (have)         |
             |                                                         |
             |                                                         |
             +---1:n---------------------------------------------------+
                (selected)</pre></p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">Schema と Campus</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p>Campus は ter のグラフを管理する単位です。</p>
                <p>Schema は er のグラフを管理する単位です。</p>
                <p>Campus と Schema はそれぞれ一つづつのグラフ(banshou)を持ちます。</p>
                <p>持っているグラフ(banshou)に図形を追加して作図します。</p>
            </div>
        </div>
    </section>

</page-core_tab-readme>
