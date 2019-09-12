<page-ter_tab-entities>

    <section class="section">
        <div class="container">

            <div class="contents">
                <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" style="font-size:12px;">
                    <thead>
                        <tr>
                            <th rowspan="2">ID</th>
                            <th rowspan="2">Class</th>
                            <th rowspan="2">Code</th>
                            <th rowspan="2">Name</th>
                            <th colspan="2">Position</th>
                            <th colspan="2">Size</th>
                            <th rowspan="2">description</th>
                        </tr>
                        <tr>
                            <th>x</th>
                            <th>y</th>
                            <th>w</th>
                            <th>h</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr each={obj in list()}>
                            <td nowrap>{obj._id}</td>
                            <td nowrap>{obj._class}</td>
                            <td nowrap>{obj.code}</td>
                            <td>{obj.name}</td>
                            <td class="num" nowrap>{num(obj.position.x)}</td>
                            <td class="num" nowrap>{num(obj.position.y)}</td>
                            <td class="num" nowrap>{num(obj.size.w)}</td>
                            <td class="num" nowrap>{num(obj.size.h)}</td>
                            <td>{obj.description}</td>
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
         let list = STORE.get('ter.entities.list');

         return list || [];
     };
    </script>

    <style>
     page-ter_tab-entities {
         display: block;
         width: 100%;
         height: 100%;
         margin-left: 55px;
         overflow: auto;
     }
     page-ter_tab-entities .table .num{
         text-align: right;
     }
    </style>

</page-ter_tab-entities>
