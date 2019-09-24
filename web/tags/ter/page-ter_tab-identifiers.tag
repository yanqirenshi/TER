<page-ter_tab-identifiers>

    <section class="section">
        <div class="container">

            <div class="contents">
                <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" style="font-size:12px;">
                    <thead>
                        <tr>
                            <th colspan="2">Entity</th>
                            <th colspan="5">Identifier</th>
                        </tr>
                        <tr>
                            <th>Code</th>
                            <th>Name</th>
                            <th>ID</th>
                            <th>Code</th>
                            <th>Name</th>
                            <th>Type</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr each={obj in list()}>
                            <td nowrap>{entityValue(obj, 'code')}</td>
                            <td nowrap>{entityValue(obj, 'name')}</td>
                            <td nowrap>{obj._id}</td>
                            <td nowrap>{obj.code}</td>
                            <td nowrap>{obj.name}</td>
                            <td nowrap>{obj.data_type}</td>
                            <td nowrap>{obj.description}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <script>
     this.entityValue = (obj, key) => {
         if (!obj._entity || !obj._entity._core)
             return '';

         return obj._entity._core[key];
     };
     this.num = (v) => {
         if (!v)
             return '';
         return v.toFixed(2);
     }
     this.list = () => {
         let list = STORE.get('ter.identifier_instances.list');

         return list || [];
     };
    </script>

    <style>
     page-ter_tab-identifiers {
         display: block;
         width: 100%;
         height: 100%;
         margin-left: 55px;
         overflow: auto;
     }
     page-ter_tab-identifiers .table .num{
         text-align: right;
     }
    </style>

</page-ter_tab-identifiers>
