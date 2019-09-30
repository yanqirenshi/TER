<page-modelers>

    <section class="section">
        <div class="container">
            <h1 class="title"></h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <table class="table is-bordered is-striped is-narrow is-hoverable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr each={obj in source}>
                            <td>{obj._id}</td>
                            <td>{obj.name}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <script>
     this.source = [];
     STORE.subscribe((action) => {
         if (action.type=='FETCHED-PAGES-MODELERS') {
             this.source = action.response;
             this.update();
             return;
         }
     });
     this.on('mount', () => {
         ACTIONS.fetchPagesModelers();
     });
    </script>

    <style>
     page-modelers {
         display: block;
         width: 100vw;
     }
    </style>

</page-modelers>
