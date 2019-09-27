<page-systems-granted>

    <section class="section">
        <div class="container">
            <h1 class="title">利用中</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <table class="table is-bordered is-striped is-narrow is-hoverable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Campus Count</th>
                            <th>Schema Count</th>
                        </tr>
                    </thead>

                    <tbody>
                        <tr each={obj in list()}>
                            <td>
                                <a href={idLink(obj)}>{obj._id}</a>
                            </td>
                            <td>{obj.code}</td>
                            <td>{obj.name}</td>
                            <td class="num">{obj.campuses.length}</td>
                            <td class="num">{obj.schemas.length}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <script>
     this.idLink = (obj) => {
         return location.hash + '/' + obj._id;
     };
     this.list = () => {
         let source = this.opts.source.granted;

         return [].concat(
             source.owner,
             source.editor,
             source.reader,
         );
     };
    </script>

</page-systems-granted>
