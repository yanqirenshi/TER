class Actions extends Vanilla_Redux_Actions {
    movePage (data) {
        return {
            type: 'MOVE-PAGE',
            data: data
        };
    }
    fetchEnvironment (mode) {
        API.get('/environment', function (response) {
            STORE.dispatch(this.fetchedEnvironment(mode, response));
        }.bind(this));
    }
    fetchedEnvironment (mode, response) {
        return {
            type: 'FETCHED-ENVIRONMENT',
            mode: mode,
            data: {
                schemas: {
                    active: response.SCHEMAS[0].code,
                    list: response.SCHEMAS
                },
                camera: response.CAMERA
            }
        };
    }
    makeGraphData (list) {
        let ht = {};
        for (var i in list) {
            let data = list[i];
            ht[data._id] = data;
        }
        return {ht: ht, list: list};
    }
    makeGraphRData (list) {
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
    fetchGraph (mode) {
        API.get('/graph', function (response) {
            STORE.dispatch(this.fetchedGraph(mode, response));
        }.bind(this));
    }
    fetchedGraph (mode, response) {
        return {
            type: 'FETCHED-GRAPH',
            mode: mode,
            data: {
                graph: {
                    nodes: this.makeGraphData(response.NODES),
                    edges: this.makeGraphData(response.EDGES)

                }
            }
        };
    }
    fetchEr (schema, mode) {
        let scheme_code = schema.code.toLowerCase();

        API.get('/er/' + scheme_code, function (response) {
            STORE.dispatch(this.fetchedEr(mode, response));
        }.bind(this));
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
    makeEdges (relashonships, ports) {
        let ports_ht = ports.ht;

        return relashonships.list.filter((r) => {
            let test = ((r['from-class']=='PORT-ER-OUT' || r['from-class']=='PORT-ER-IN') &&
                        (r['to-class']=='PORT-ER-OUT' || r['to-class']=='PORT-ER-IN'));
            if (test) {
                r._port_from = ports_ht[r['from-id']];
                r._port_to = ports_ht[r['to-id']];
            }
            return test;
        });
    }
    fetchedEr (mode, response) {
        let relashonships    = this.makeGraphRData(response.RELASHONSHIPS);
        let tables           = this.makeGraphData(response.TABLES);
        let column_instances = this.makeGraphData(response.COLUMN_INSTANCES);
        let ports            = this.makeGraphData(response.PORTS);
        let edges            = this.makeGraphData(this.makeEdges(relashonships, ports));

        // inject
        this.injectTable2ColumnInstances(tables, column_instances, relashonships);
        this.injectColumnInstances2Ports (column_instances, ports, relashonships);

        return {
            type: 'FETCHED-ER',
            mode: mode,
            data: {
                er: {
                    tables:           this.makeGraphData(response.TABLES),
                    columns:          this.makeGraphData(response.COLUMNS),
                    column_instances: column_instances,
                    ports:            ports,
                    relashonships:    relashonships,
                    edges:            edges,
                    cameras:          response.CAMERAS
                }
            }
        };
    }
    fetchTer (mode) {
        API.get('/ter', function (response) {
            STORE.dispatch(this.fetchedTer(mode, response));
        }.bind(this));
    }
    fetchedTer (mode, response) {
        return {
            type: 'FETCHED-TER',
            mode: mode,
            data: {
                ter: {
                    nodes: this.makeGraphData(response.NODES),
                    edges: this.makeGraphData(response.EDGES)
                }
            }
        };
    }
    savePosition (schema, table) {
        let scheme_code = schema.code.toLowerCase();

        let path = '/er/' + scheme_code + '/tables/' + table.code + '/position';
        let data = {x: table.x, y:table.y, z:0};
        API.post(path, data, ()=>{});
    }
    saveCameraLookAt (camera, look_at) {
        let _look_at = Object.assign({}, look_at);
        let path = '/camera/' + camera.code + '/look-at';
        let data = {
            x: _look_at.x || 0,
            y: _look_at.y || 0,
            z: _look_at.z || 0
        };
        API.post(path, data, ()=>{});
    }
    saveCameraLookMagnification (camera, magnification) {
        let path = '/camera/' + camera.code + '/magnification';
        let data = {
            magnification: magnification || 1
        };
        API.post(path, data, ()=>{});
    }
    changeSchema (schema_code) {
        let schemas = STORE.state().get('schemas');

        schemas.active = schema_code;

        return {
            type: 'CHANGE-SCHEMA',
            data: {
                schemas: schemas
            }
        };
    }
}
