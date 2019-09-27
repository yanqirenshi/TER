<page-system>

    <div class="page-root">
        <div style="padding: 22px 33px;">
            <section-breadcrumb></section-breadcrumb>
        </div>

        <section class="section">
            <div class="container">
                <h1 class="title">Systems</h1>
                <h2 class="subtitle"></h2>

                <div class="contetns" style="margin-left:22px;">
                    <table class="table is-bordered is-striped is-narrow is-hoverable">
                        <tbody>
                            <tr> <th>ID</th>           <td>{systemVal('id')}</td> </tr>
                            <tr> <th>Code</th>         <td>{systemVal('code')}</td> </tr>
                            <tr> <th>Name</th>         <td>{systemVal('name')}</td> </tr>
                            <tr> <th>Description</th>  <td>{systemVal('description')</td> </tr>

                        </tbody>
                    </table>
                </div>

            </div>
        </section>

        <page-base-campuses source={this.source.campuses}></page-base-campuses>
        <page-base-schemas source={this.source.schemas}></page-base-schemas>
    </div>

    <script>
     this.systemVal = (key) => {
         if (!this.source.system)
             return '';

         return this.source.system[key];
     }
    </script>

    <script>
     this.on('mount', () => {
         let id = location.hash.split('/').reverse()[0] * 1;

         ACTIONS.fetchPagesSystem(id);
     });
     this.source = {
         system: null,
         campuses: [],
         schemas: [],
     }
     STORE.subscribe((action) => {
         if (action.type=='FETCHED-PAGES-SYSTEM') {
             this.source = action.response;
             this.update();

             return;
         }
     });
    </script>

    <style>
     page-system {
         display: block;
         width: 100%;
         padding-left: 111px;
     }
    </style>

</page-system>
