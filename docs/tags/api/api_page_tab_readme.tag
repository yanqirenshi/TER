<api_page_tab_readme>

    <section class="section">
        <div class="container">
            <h1 class="title">README</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <table class="table is-bordered is-striped is-narrow is-hoverable">
                    <thead>
                        <tr>
                            <th>Method</th>
                            <th>Path</th>
                            <th>実装</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr each={obj in list}>
                            <td>{obj.method}</td>
                            <td><code>{obj.path}</code></td>
                            <td>{obj.implementation ? "○" : "×"}</td>
                            <td>{obj.description}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <script>
     this.list = [
         { path: "/environments",                                                         method: "GET",  implementation: true, description: '' },
         //
         { path: "/pages/managements",                                                    method: "GET",  implementation: true, description: '' },
         { path: "/pages/modelers",                                                       method: "GET",  implementation: true, description: '' },
         { path: "/pages/systems",                                                        method: "GET",  implementation: true, description: '' },
         { path: "/pages/systems/:id",                                                    method: "GET",  implementation: true, description: '' },
         //
         { path: "/rpc/snapshot/all",                                                     method: "GET",  implementation: true, description: 'これは /ter/:campus-id/snapshot とかにすべきじゃないかな。' },
         //
         { path: "/systems",                                                              method: "POST", implementation: true, description: '' },
         { path: "/systems/:id/active",                                                   method: "POST", implementation: true, description: '' },
         { path: "/systems/:sytem-id/campuses/:campus-id/entities",                       method: "POST", implementation: true, description: '/ter/:campus-code/entities と同じ？' },
         //
         { path: "/ter/:campus-code/environments",                                        method: "GET",  implementation: true, description: '' },
         { path: "/ter/:campus-code/cameras/:camera-code/look-at",                        method: "POST", implementation: true, description: '' },
         { path: "/ter/:campus-code/cameras/:camera-code/magnification",                  method: "POST", implementation: true, description: '' },
         { path: "/ter/:campus-code/entities",                                            method: "GET",  implementation: true, description: '' },
         { path: "/ter/:campus-code/entities/:entity-code/location",                      method: "POST", implementation: true, description: '' },
         { path: "/ter/:campus-code/identifiers",                                         method: "GET",  implementation: true, description: '' },
         { path: "/ter/:campus-code/attributes",                                          method: "GET",  implementation: true, description: '' },
         { path: "/ter/:campus-code/ports",                                               method: "GET",  implementation: true, description: '' },
         { path: "/ter/:campus-code/ports/:port-id/location",                             method: "POST", implementation: true, description: '' },
         { path: "/ter/:campus-code/edges",                                               method: "GET",  implementation: true, description: '' },
         //
         { path: "/er/:schema_code/environments",                                         method: "GET",  implementation: true, description: '' },
         { path: "/er/schemas/:schema-code/camera/:camera-code/look-at",                  method: "POST", implementation: true, description: '修正要：/er/schemas → /er' },
         { path: "/er/schemas/:schema-code/camera/:camera-code/magnification",            method: "POST", implementation: true, description: '修正要：/er/schemas → /er' },
         { path: "/er/:schema-code/tables/:table-code/columns/:column-code/logical-name", method: "POST", implementation: true, description: '' },
         { path: "/er/:schema-code/tables/:table-code/description",                       method: "POST", implementation: true, description: '' },
         { path: "/er/:schema_code/tables/:code/position",                                method: "POST", implementation: true, description: '' },
         { path: "/er/:schema_code/tables/:code/size",                                    method: "POST", implementation: true, description: '' },
         { path: "/er/:schema-code/columns/instance/:id/description",                     method: "POST", implementation: true, description: '' },
         { path: "/er/:schema_code/nodes",                                                method: "GET",  implementation: true, description: '' },
         { path: "/er/:schema_code/edges",                                                method: "GET",  implementation: true, description: '' },
     ];
    </script>

</api_page_tab_readme>
