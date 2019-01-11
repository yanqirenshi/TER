<inspector-entity-ports-positions>
    <div style="margin-top:22px;">
        <h1 class="title is-7">Positions</h1>
        <table class="table is-bordered is-striped is-narrow is-hoverable">
            <thead>
                <tr>
                    <th rowspan="2">ID</th>
                    <th colspan="3">Position</th>
                </tr>
                <tr>
                    <th>degree</th>
                    <th>x</th>
                    <th>y</th>
                </tr>
            </thead>
            <tbody>
                <tr each={port in opts.ports}>
                    <td>{port._core._id}</td>
                    <td>{port._core.position}</td>
                    <td>{Math.floor(port.position.x * 100)/100}</td>
                    <td>{Math.floor(port.position.y * 100)/100}</td>
                </tr>
            </tbody>
        </table>
    </div>
</inspector-entity-ports-positions>
