<page-core_tab-readme>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">データの構成(基礎)</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p><pre>今はこれ. ちょっと混乱ぎみ。
---------------------------
ghost-shadow                       +---1:n---> schema ---1:n---+
     |                             |  (have)            (have) |
    1:1      +---1:n---> system ---|                           +---> camera
     |       |  (selected)         |                           |       ^
     V       |                     `---1:n---> campus ---1:n---+       |
  modeler ---+                        (have)            (have)         |
             |                                                         |
             |                                                         |
             +---1:n---------------------------------------------------+
                (selected)


最終はこれ. がいいな。
-----------------------
ghost-shadow
     |
    1:1
     |       +---1:n---> system ---1:n---> schema ---1:n---> campus
     V       |  (selected)        (have)            (have)     |
  modeler ---+                                                1:n (have)
             |                                                 |
             +---1:n---> camera <------------------------------+
                (selected)</pre></p>
            </div>
        </div>
    </section>

</page-core_tab-readme>
