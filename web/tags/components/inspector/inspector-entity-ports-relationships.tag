<inspector-entity-ports-relationships>
    <div style="margin-top:22px;">
        <table class="table is-bordered is-striped is-narrow is-hoverable">
            <thead>
                <tr>
                    <th rowspan="3">ID</th>
                    <th colspan="3">Relationship</th>
                </tr>
                <tr>
                    <th rowspan="2">from</th>
                    <th colspan="2">to</th>
                </tr>
                <tr>
                    <!-- <th>entity</th> -->
                    <!-- <th>identifier</th> -->

                    <th>entity</th>
                    <th>identifier</th>
                </tr>
            </thead>
            <tbody>
                <tr each={port in opts.ports}>
                    <td>{port._core._id}</td>

                    <!-- <td>{fromEntity(port)}</td> -->
                    <td>{fromIdentiferName(port)}</td>

                    <td>{toEntity(port)}</td>
                    <td>{toIdentiferName(port)}</td>
                </tr>
            </tbody>
        </table>
    </div>

    <script>
     this.getEdge = (port) => {
         let port_id = port._core._id;
         let port_direction = port._core.direction;

         let state = STORE.get('ter');
         let edges_index = state.relationships.indexes;

         let edges;
         if (port_direction=="IN")
             edges = edges_index.to[port_id];
         else if (port_direction=="OUT")
             edges = edges_index.from[port_id];
         else
             throw new Error('??? port.direction=' + port_direction);

         for (let key in edges)
             if (edges[key].from_class=='PORT-TER' && edges[key].to_class=='PORT-TER')
                 return edges[key];

         return null;
     };
     this.getToPortID = (state, port) => {
         let edge = this.getEdge(port);
         let port_direction = port._core.direction;
         let ports_ht = state.ports.ht;

         if (port_direction=="IN")
             return ports_ht[edge.from_id];
         else if (port_direction=="OUT")
             return ports_ht[edge.to_id];
         else
             throw new Error('??? port.direction=' + port_direction);
     };
     this.getPortIdentifier = (state, port) => {
         let edges = state.relationships.indexes.to[port._id];

         let identifiers_ht = state.identifier_instances.ht;
         for (let key in edges)
             if (edges[key].from_class=='IDENTIFIER-INSTANCE')
                 return identifiers_ht[edges[key].from_id];

         return null
     }
    </script>

    <script>
     this.toIdentifer = (port) => {
         let state = STORE.get('ter');

         let to_port = this.getToPortID(state, port);

         return this.getPortIdentifier(state, to_port);
     }
     this.toIdentiferName = (port) => {
         let identifier = this.toIdentifer(port);

         return identifier ? identifier.name : '';
     };
     this.toEntity = (port) => {
         let identifier = this.toIdentifer(port);

         return identifier ? identifier._entity._core.name : '';
     }
     this.fromIdentifer = (port) => {
         let state = STORE.get('ter');

         return this.getPortIdentifier(state, port);
     }
     this.fromIdentiferName = (port) => {
         let identifier = this.fromIdentifer(port);

         return identifier ? identifier.name : '';
     }
     this.fromEntity = (port) => {
         let identifier = this.fromIdentifer(port);

         return identifier ? identifier._entity._core.name : '';
     }
    </script>

    <style>
     inspector-entity-ports-relationships { display: block;}
    </style>
</inspector-entity-ports-relationships>
