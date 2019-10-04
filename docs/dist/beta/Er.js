class ErDataManeger {
    makeGraphData (list) {
        let ht = {};
        for (var i in list) {
            let data = list[i];
            ht[data._id] = data;
        }
        return {ht: ht, list: list};
    }
    makeGraphDataR (list) {
        let ht = {};
        let ht_from = {};
        let ht_to = {};
        for (var i in list) {
            let data = list[i];
            let _id = data._id;
            let from_id = data['from-id'];
            let to_id = data['to-id'];

            // _id
            ht[_id] = data;

            // from_id
            if (!ht_from[from_id])
                ht_from[from_id] = {};
            ht_from[from_id][to_id] = data;

            // to_id
            if (!ht_to[to_id])
                ht_to[to_id] = {};
            ht_to[to_id][from_id] = data;
        }

        return {
            ht: ht,
            list: list,
            from: ht_from,
            to: ht_to
        };
    }
    makeEdges (relashonships, ports) {
        let ports_ht = ports.ht;

        return relashonships.list.filter((r) => {
            let test = ((r['from-class']=='PORT-ER-OUT' || r['from-class']=='PORT-ER-IN') &&
                        (r['to-class']=='PORT-ER-OUT' || r['to-class']=='PORT-ER-IN'));
            if (test) {
                let port_from = ports_ht[r['from-id']];
                let port_to   = ports_ht[r['to-id']];

                r._port_from = port_from;
                r._port_to   = port_to;

                let table_from = port_from._column_instance._table;
                let table_to   = port_to._column_instance._table;

                if (!table_from._edges) table_from._edges = [];
                if (!table_to._edges)   table_to._edges   = [];

                table_from._edges.push(r);
                table_to._edges.push(r);
            }
            return test;
        });
    }
    injectTable2ColumnInstances (tables, column_instances, relashonships) {
        let table_ht = tables.ht;
        for (var i in column_instances.list) {
            let column_instance = column_instances.list[i];
            let to_ht = relashonships.to[column_instance._id];

            for (var k in to_ht)
                if (to_ht[k]['from-class'] == 'TABLE') {
                    column_instance._table = to_ht[k];

                    let from_id = to_ht[k]['from-id'];
                    column_instance._table = table_ht[from_id];


                    if (!table_ht[k]._column_instances)
                        table_ht[k]._column_instances = [];

                    table_ht[k]._column_instances.push(column_instance);
                }
        }
    }
    injectColumnInstances2Ports (column_instances, ports, relashonships) {
        let column_instances_ht = column_instances.ht;
        for (var i in ports.list) {
            let port = ports.list[i];
            let to_ht = relashonships.to[port._id];

            for (var k in to_ht)
                if (to_ht[k]['from-class'] == 'COLUMN-INSTANCE') {
                    let from_id = to_ht[k]['from-id'];
                    port._column_instance = column_instances_ht[from_id];

                    if (!port._column_instance._table._ports)
                        port._column_instance._table._ports = [];
                    port._column_instance._table._ports.push(port);
                }
        }
    }
    /////
    ///// response
    /////
    responseNode2Data (response, state) {
        let relashonships    = this.makeGraphDataR(response.RELASHONSHIPS);
        let tables           = this.makeGraphData(response.TABLES);
        let column_instances = this.makeGraphData(response.COLUMN_INSTANCES);
        let ports            = this.makeGraphData(response.PORTS);

        // inject
        this.injectTable2ColumnInstances(tables, column_instances, relashonships);
        this.injectColumnInstances2Ports (column_instances, ports, relashonships);

        state.tables =           this.makeGraphData(response.TABLES);
        state.columns =          this.makeGraphData(response.COLUMNS);
        state.column_instances = column_instances;
        state.ports =            ports;
        state.relashonships =    relashonships;

        return state;
    }
    responseEdge2Data (relashonships, ports) {
        return this.makeGraphData(this.makeEdges(relashonships, ports));
    }
    /////
    ///// import
    /////
    import2Data (import_data) {
    }
}

class Er extends ErDataManeger {
    constructor (options) {
        super();

        this._table = null;

        this._values    = this.initValues(options);
        this._callbacks = this.initCallbacks(options);
    }
    initValues (options) {
        let default_values = {
            table: {
                columns: {
                    column: {
                        value: 'logical_name', // 'physical_name'
                    }
                },
            },
        };

        if (!options.values)
            return default_values;

        return Object.assign({}, options.values);
    }
    initCallbacks (options) {
        let default_callbacks = {
            table: {
                move: {
                    end: (d) => {}
                },
                resize: (table) => {},
                header: {
                    click: (d) => {}
                },
                columns: {
                    click: (d) => {}
                },
            }
        };

        if (!options.callbacks)
            return default_callbacks;

        return options.callbacks;
    }
    // Common
    random (v, type) {
        let min;
        let max;

        if (type=='x') {
            min = 11;
            max = v - 11;
        }
        if (type=='y') {
            min = 11;
            max = v * 2 - 11;
        }
        return Math.floor( Math.random() * (max + 1 - min) ) + min ;
    }
    // ER
    clear (d3svg) {
        if (!this._table) this._table = new ErTable({ d3svg:d3svg });

        this._table.removeAll();
    }
    drawEdges (d3svg, state) {
        let svg = d3svg._svg;

        this._Edge = new Edge();
        this._Edge.draw(svg, state.edges.list);
    }
    moveEdges (d3svg, tables) {
        let svg = d3svg._svg;

        this._Edge = new Edge();
        this._Edge.moveEdges(svg, ([[]].concat(tables)).reduce((a,b) => {
            return b._edges ? a.concat(b._edges) : a;
        }));
    }
    drawTablesCore (d3svg, state) {
        if (!this._table)
            this._table = new ErTable({
                d3svg:d3svg,
                values: this._values,
                callbacks: this._callbacks.table,
            });

        let tables = state.tables.list;
        this._table.draw(tables);

        return tables;
    }
    drawTables (d3svg, state) {
        this.drawEdges(d3svg, state);

        let tables = this.drawTablesCore(d3svg, state);

        this.moveEdges(d3svg, tables);
    }
    reDrawTable (table) {
        if (table)
            this._table.reDraw(table);
    }
    stateER2Json (state) {
        let out = {};

        out.tables  = state.tables.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            delete new_data._column_instances;
            delete new_data._edges;
            delete new_data._ports;

            return new_data;
        });
        out.columns = state.columns.list.slice();
        out.cameras = state.cameras.slice();
        out.column_instances = state.column_instances.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            delete new_data._table;

            return new_data;
        });

        out.ports = state.ports.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            delete new_data._column_instance;

            return new_data;
        });

        out.relashonships = state.relashonships.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            delete new_data._port_from;
            delete new_data._port_to;

            return new_data;
        });

        out.edges = state.edges.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            delete new_data._port_from;
            delete new_data._port_to;

            return new_data;
        });

        return JSON.stringify(out, null, 3);
    }
    downloadJson (name, json) {
        var blob = new Blob([ json ], {type : 'application/json'});

        var a = document.createElement("a");
        a.href = URL.createObjectURL(blob);
        a.target = '_blank';
        a.download = name + '.' + moment().format('YYYYMMDDHHmmssZZ') + '.json';
        a.click();

    }
}
