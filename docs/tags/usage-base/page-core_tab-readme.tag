<page-core_tab-readme>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">データの構成(基礎)</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p><pre> ghost-shadow
      o
      |
      +---1:1----> Email ---1:1---> Email-key  // TODO: 未設計
      |
      |                         +-------+
      +--- edge-force [1:n] --->| force |
      |                         +-------+
     1:1
      |
      V
 +---------+                          +--------+                   +--------+                     +--------+
 | modeler |o--- edge [1:1] --------->|        |o--- edge [1:n]--->| schema |o--- edge [1:n] o--->|        |
 |         |     (selected)           |        |     (have)        |  [er]  |     (have)          |        |
 |         |                          | system |                   +--------+                     | camera |
 |         |                          |        |                   +--------+                     |        |
 |         |o--- edge-grant [1:1] --->|        |o----edge [1:n]--->| campus |o--- edge [1:n] o--->|        |
 |         |                          +--------+     (have)        |  [ter] |     (have)p         |        |
 |         |                                                       +--------+                     |        |
 |         |o--- edge [1:1] --------------------------------------------------------------------->|        |
 +---------+     (selected)                                                                       +--------+</pre></p>
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

    <style>
     page-core_tab-readme pre {
         font-size: 14px;
         line-height: 13px;
     }
    </style>

</page-core_tab-readme>
