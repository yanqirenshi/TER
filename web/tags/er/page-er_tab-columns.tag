<page-er_tab-columns>

    <section class="section">
        <div class="container">

            <div class="contents">
                <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" style="font-size:12px;">
                    <thead>
                        <tr>
                            <th colspan="2">Table</th>
                            <th colspan="6">Identifier</th>
                        </tr>
                        <tr>
                            <th>Code</th>
                            <th>Name</th>
                            <th>ID</th>
                            <th>Code</th>
                            <th>Physical Name</th>
                            <th>Logical Name</th>
                            <th>Type</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr each={obj in list()}>
                            <td nowrap>{obj._table.code}</td>
                            <td nowrap>{obj._table.name}</td>
                            <td nowrap>{obj._id}</td>
                            <td nowrap>{obj.code}</td>
                            <td nowrap>{obj.physical_name}</td>
                            <td nowrap>{obj.logical_name}</td>
                            <td nowrap>{obj.data_type}</td>
                            <td nowrap>{obj.description}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>

    <script>
     this.num = (v) => {
         if (!v)
             return '';
         return v.toFixed(2);
     }
     this.list = () => {
         let list = STORE.get('er.column_instances.list');

         return list || [];
     };
    </script>

    <style>
     page-er_tab-columns {
         display: block;
         width: 100%;
         height: 100%;
         margin-left: 55px;
         overflow: auto;
     }
     page-er_tab-columns .table .num{
         text-align: right;
     }
    </style>

</page-er_tab-columns>
