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
         { version: 'beta',  description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/Er.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/Er.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/ErEdge.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/ErPort.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/ErTable.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/ErTableColumn.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/Ter.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/TerAttribute.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/TerEdge.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/TerEntity.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/TerIdentifier.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/TerPort.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/Er.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/ErEdge.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/ErPort.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/ErTable.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/ErTableColumn.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/Ter.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/TerAttribute.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/TerEdge.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/TerEntity.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/TerIdentifier.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/TerPort.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/Er.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/ErEdge.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/ErPort.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/ErTable.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/ErTableColumn.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/Ter.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/TerAttribute.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/TerEdge.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/TerEntity.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/TerIdentifier.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/TerPort.js' },
     ];
    </script>

</home_page_root>
