<home_page_root>
    <section-header title="TER Docs"></section-header>

    <section class="section">
        <div class="container">
            <h1 class="title">CDN</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <table class="table is-bordered is-striped is-narrow is-hoverable">
                    <thead>
                        <tr>
                            <th>Version</th>
                            <th>Url</th>
                            <th>Description</th>
                        </tr>
                    </thead>

                    <tbody>
                        <tr each={rec in cdn}>
                            <td>{rec.version}</td>
                            <td><a href={rec.url}>{rec.url}</a></td>
                            <td>{rec.description}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <script>
     this.cdn = [
         { version: 'beta',  description: '0.0.2に向けて開発中のもの。', url: 'https://yanqirenshi.github.io/TER/dist/beta/Er.js' },
         { version: '0.0.1', description: '',                            url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/Er.js' },
     ];
    </script>

</home_page_root>
