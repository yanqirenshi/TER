<web_page_ter_tab_home>
    <section class="section">
        <div class="container">
            <h1 class="title">Usage</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p>
                    <pre><code>
let d3svg = makeD3Svg();
let svg = d3svg.Svg();
let forground = svg.selectAll('g.base.forground');

new Entity()
    .data(state)
    .sizing()
    .positioning()
    .draw(forground);</code></pre>
                </p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title">State</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <p>Data は連想配列です。</p>
                <p>Data のキーは以下の通りです。</p>
                <table class="table">
                    <thead><tr><th>Key</th><th>Description</th></tr></thead>
                    <tbody>
                        <tr> <td>entities</td>             <td></td> </tr>
                        <tr> <td>identifier_instances</td> <td></td> </tr>
                        <tr> <td>attribute_instances</td>  <td></td> </tr>
                        <tr> <td>ports</td>                <td></td> </tr>
                        <tr> <td>relationships</td>        <td></td> </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title">Class: Entity</h1>

            <section class="section">
                <div class="container">
                    <h1 class="title">Methos</h1>
                    <div class="contents">
                        <table class="table">
                            <thead><tr><th>Key</th><th>Description</th></tr></thead>
                            <tbody>
                                <tr> <td>data</td>        <td></td> </tr>
                                <tr> <td>sizing</td>      <td></td> </tr>
                                <tr> <td>positioning</td> <td></td> </tr>
                                <tr> <td>draw</td>        <td></td> </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </section>
</web_page_ter_tab_home>
