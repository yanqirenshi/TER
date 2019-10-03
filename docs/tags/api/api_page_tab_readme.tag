<api_page_tab_readme>

    <section class="section">
        <div class="container">
            <h1 class="title">README</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <table class="table is-bordered is-striped is-narrow is-hoverable">
                    <thead>
                        <tr>
                            <th rowspan="2">Method</th>
                            <th rowspan="2">Path</th>
                            <th rowspan="2">実装</th>
                            <th colspan="3">権限</th>
                            <th rowspan="2">Description</th>
                        </tr>
                        <tr>
                            <th>Owner</th>
                            <th>Writer</th>
                            <th>Reader</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr each={obj in list}>
                            <td>{obj.method}</td>
                            <td><code>{obj.path}</code></td>
                            <td>{obj.implementation   ? "○" : "×"}</td>
                            <td>{obj.authority.owner  ? "○" : "×"}</td>
                            <td>{obj.authority.writer ? "○" : "×"}</td>
                            <td>{obj.authority.reader ? "○" : "×"}</td>
                            <td>{obj.description}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <script>
     this.list = [
         { path: "/environments", method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         //
         { path: "/pages/managements", method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/pages/modelers",    method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/pages/systems",     method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/pages/systems/:id", method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         //
         { path: "/rpc/snapshot/all", method: "GET",  implementation: true, description: 'これは /ter/:campus-id/snapshot とかにすべきじゃないかな。', authority: { owner: true, writer: true, reader: true } },
         //
         { path: "/systems",                                        method: "POST", implementation: true, description: 'System の作成', authority: { owner: true, writer: true, reader: true } },
         { path: "/systems/:id/active",                             method: "POST", implementation: true, description: 'System の選択', authority: { owner: true, writer: true, reader: true } },
         { path: "/systems/:sytem-id/campuses/:campus-id/entities", method: "POST", implementation: true, description: 'Entity の追加。 でも/ter/:campus-code/entities と被るな。。。。', authority: { owner: true, writer: true, reader: false } },
         //
         { path: "/ter/campuses/:campus-id/environments",                     method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/ter/campuses/:campus-id/cameras/:camera-id/look-at",       method: "POST", implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/ter/campuses/:campus-id/cameras/:camera-id/magnification", method: "POST", implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/ter/campuses/:campus-id/entities",                         method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/ter/campuses/:campus-id/entities/:entity-id/location",     method: "POST", implementation: true, description: '', authority: { owner: true, writer: true, reader: false } },
         { path: "/ter/campuses/:campus-id/identifiers",                      method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/ter/campuses/:campus-id/attributes",                       method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/ter/campuses/:campus-id/ports",                            method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/ter/campuses/:campus-id/ports/:port-id/location",          method: "POST", implementation: true, description: '', authority: { owner: true, writer: true, reader: false } },
         { path: "/ter/campuses/:campus-id/edges",                            method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         //
         { path: "/er/schemas/:schema-id/environments",                                              method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/er/schemas/:schema-id/nodes",                                                     method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/er/schemas/:schema-id/edges",                                                     method: "GET",  implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/er/schemas/:schema-id/cameras/:camera-id/look-at",                                method: "POST", implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/er/schemas/:schema-id/cameras/:camera-id/magnification",                          method: "POST", implementation: true, description: '', authority: { owner: true, writer: true, reader: true } },
         { path: "/er/schemas/:schema-id/tables/:table-id/description",                              method: "POST", implementation: true, description: '', authority: { owner: true, writer: true, reader: false } },
         { path: "/er/schemas/:schema-id/tables/:table-id/position",                                 method: "POST", implementation: true, description: '', authority: { owner: true, writer: true, reader: false } },
         { path: "/er/schemas/:schema-id/tables/:table-id/size",                                     method: "POST", implementation: true, description: '', authority: { owner: true, writer: true, reader: false } },
         { path: "/er/schemas/:schema-id/tables/:table-id/column-instances/:column-id/logical-name", method: "POST", implementation: true, description: 'columns → column-instane が正しいな。。。', authority: { owner: true, writer: true, reader: false } },
         { path: "/er/schemas/:schema-id/tables/:table-id/column-instances/:column-id/description",  method: "POST", implementation: true, description: 'これは logical-name のヤツに合わせたほうがよさそう。', authority: { owner: true, writer: true, reader: false } },
     ];
    </script>

</api_page_tab_readme>
