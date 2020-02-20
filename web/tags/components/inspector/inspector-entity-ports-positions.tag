<inspector-entity-ports-positions>

        <h1 class="title is-6" style="margin-bottom:11px;" >Positions</h1>

        <table class="table is-bordered is-striped is-narrow is-hoverable ter-table">
            <thead>
                <tr>
                    <th rowspan="2">ID</th>
                    <th colspan="3">Position</th>
                </tr>
                <tr>
                    <th>x</th>
                    <th>y</th>
                    <th>degree</th>
                </tr>
            </thead>
            <tbody>
                <tr each={port in opts.ports}>
                    <td>{port._core._id}</td>
                    <td>{Math.floor(port.position.x * 100)/100}</td>
                    <td>{Math.floor(port.position.y * 100)/100}</td>
                    <td>
                        <input class="input is-small"
                               type="text"
                               placeholder="Degree"
                               value="{port._core.position}"
                               ref="degree-{port._core._id}" />
                        <button class="button is-small"
                                onclick={clickSaveDegree}
                                port-id={port._core._id}>Save</button>
                    </td>
                </tr>
            </tbody>
        </table>

        <script>
         this.getDegree = (port_id) => {
             let key = 'degree-'+port_id;
             let str = this.refs[key].value;

             return parseFloat(str);
         };
         this.clickSaveDegree = (e) => {
             let port_id = e.target.getAttribute('port-id');

             let port = opts.ports.find((d) => { return d._id = port_id; });
             let degree = this.getDegree(port_id);

             let campus = STORE.get('active.ter.campus');

             ACTIONS.saveTerPortPosition(campus, port, degree);
         };
        </script>

        <style>
         inspector-entity-ports-positions { display: block; }

         inspector-entity-ports-positions .table td {
             vertical-align: middle;
         }
         inspector-entity-ports-positions .table td .input {
             text-align: right;
             width:66px;
         }
        </style>
</inspector-entity-ports-positions>
