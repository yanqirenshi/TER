<inspector-table-relationship>
    <div class="contents">
        <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth ter-table"">
            <thead>
                <tr><th>Type</th><th>From</th><th>To</th></tr>
            </thead>
            <tbody>
                <tr each={edges()}>
                    <td>{data_type}</td>
                    <td>{_port_from._column_instance._table.name}</td>
                    <td>{_port_to._column_instance._table.name}</td>
                </tr>
            </tbody>
        </table>
    </div>

    <script>
     this.edges = () => {
         if (this.opts && this.opts.data && this.opts.data._edges)
             return this.opts.data._edges

         return [];
     };
    </script>
</inspector-table-relationship>
