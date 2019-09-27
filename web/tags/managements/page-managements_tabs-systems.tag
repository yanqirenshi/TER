<page-managements_tabs-systems>

    <section class="section">
        <div class="container">
            <h1 class="title">Systems</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <table class="table is-bordered is-striped is-narrow is-hoverable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Description</th>
                        </tr>
                    </thead>

                    <tbody>
                        <tr each={obj in list()}>
                            <td>
                                <a href={idLink(obj._id)}>
                                    {obj._id}
                                </a>
                            </td>
                            <td>{obj.code}</td>
                            <td>{obj.name}</td>
                            <td>{obj.description}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <script>
     this.idLink = (v) => {
         return location.hash + '/systems/' + v;
     };
     this.list = () => {
         return this.opts.source.systems || [];
     };
    </script>

    <style>
     page-managements_tabs-systems {
         display: block;
         width: 100%;
     }
    </style>

</page-managements_tabs-systems>
