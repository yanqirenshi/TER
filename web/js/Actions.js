class Actions extends Vanilla_Redux_Actions {
    movePage (data) {
        return {
            type: 'MOVE-PAGE',
            data: data
        };
    }
    /* **************************************************************** *
     *  Save Config
     * **************************************************************** */
    saveConfigAtDefaultSchema (schema_code) {
        let data = {
            schema_code: schema_code
        };

        API.post('/environment/er/schema/active', data, (response) => {
            STORE.dispatch(this.savedConfigAtDefaultSchema(response));
        });
    }
    savedConfigAtDefaultSchema (response) {
        return {
            type: 'SAVED-CONFIG-AT-DEFAULT-SCHEMA',
            data: {}
        };
    }
    /* **************************************************************** *
     *  Fetch Environment
     * **************************************************************** */
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
                    active: response.ER.SCHEMA.ACTIVE,
                    list: response.SCHEMAS
                },
                camera: response.CAMERA
            }
        };
    }
    /* **************************************************************** *
     *  Fetch Graph
     * **************************************************************** */
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
    /* **************************************************************** *
     *  Fetch ER
     * **************************************************************** */
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
                let port_from = ports_ht[r['from-id']];
                let port_to = ports_ht[r['to-id']];

                r._port_from = port_from;
                r._port_to = port_to;

                let table_from = port_from._column_instance._table;
                let table_to   = port_to._column_instance._table;

                if (!table_from._edges) table_from._edges = [];
                if (!table_to._edges)   table_to._edges = [];

                table_from._edges.push(r);
                table_to._edges.push(r);
            }
            return test;
        });
    }
    fetchedEr (mode, response) {
        let relashonships    = this.makeGraphRData(response.RELASHONSHIPS);
        let tables           = this.makeGraphData(response.TABLES);
        let column_instances = this.makeGraphData(response.COLUMN_INSTANCES);
        let ports            = this.makeGraphData(response.PORTS);

        // inject
        this.injectTable2ColumnInstances(tables, column_instances, relashonships);
        this.injectColumnInstances2Ports (column_instances, ports, relashonships);

        // edges
        let edges            = this.makeGraphData(this.makeEdges(relashonships, ports));

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
    //
    fetchErNodes (schema, mode) {
        let scheme_code = schema.code.toLowerCase();

        API.get('/er/' + scheme_code + '/nodes', function (response) {
            STORE.dispatch(this.fetchedErNodes(mode, response));
        }.bind(this));
    }
    fetchedErNodes (mode, response) {
        let relashonships    = this.makeGraphRData(response.RELASHONSHIPS);
        let tables           = this.makeGraphData(response.TABLES);
        let column_instances = this.makeGraphData(response.COLUMN_INSTANCES);
        let ports            = this.makeGraphData(response.PORTS);

        this.injectTable2ColumnInstances(tables, column_instances, relashonships);
        this.injectColumnInstances2Ports (column_instances, ports, relashonships);

        return {
            type: 'FETCHED-ER-NODES',
            mode: mode,
            data: {
                er: {
                    tables:           this.makeGraphData(response.TABLES),
                    columns:          this.makeGraphData(response.COLUMNS),
                    column_instances: column_instances,
                    ports:            ports,
                    relashonships:    relashonships,
                    cameras:          response.CAMERAS
                }
            }
        };
    }
    //
    fetchErEdges (schema, mode) {
        let scheme_code = schema.code.toLowerCase();

        API.get('/er/' + scheme_code + '/edges', function (response) {
            STORE.dispatch(this.fetchedErEdges(mode, response));
        }.bind(this));
    }
    fetchedErEdges (mode, response) {
        let er               = STORE.state().get('er');
        let relashonships    = er.relashonships;
        let ports            = er.ports;

        er.edges = this.makeGraphData(this.makeEdges(relashonships, ports));

        return {
            type: 'FETCHED-ER-EDGES',
            mode: mode,
            data: { er: er }
        };
    }
    saveTableDescription (schema_code, table, description, from) {
        let fmt = '/er/%s/tables/%s/description';
        let path = fmt.format(schema_code, table.code);
        let data = { contents: description };

        API.post(path, data, (resource)=>{
            STORE.dispatch(this.savedTableDescription(resource, from));
        });
    }
    savedTableDescription (resource, from) {
        let state = STORE.get('er');
        let ht = state.tables.ht;
        let source = resource;
        let target = ht[source._id];

        target.description = source.description;

        return {
            type: 'SAVED-TABLE-DESCRIPTION',
            data: { er: state },
            from: from,
        };
    }
    /* **************************************************************** *
     *  table
     * **************************************************************** */
    saveColumnInstanceLogicalName (data, from) {
        let fmt = '/er/%s/tables/%s/columns/%s/logical-name';
        let path = fmt.format(data.schema_code, data.table_code, data.column_instance_code);

        let post_data = data.logical_name;

        API.post(path, post_data, (response)=>{
            STORE.dispatch(this.savedColumnInstanceLogicalName(response, from));
        });
    }
    savedColumnInstanceLogicalName (data, from) {
        let state_er = null;
        let column_instance = null;

        if (data) {
            let _id = data._id;
            state_er = STORE.state().get('er');

            column_instance = state_er.column_instances.ht[_id];
            column_instance.code = data.code;
            column_instance.column_type = data.column_type;
            column_instance.data_type = data.data_type;
            column_instance.logical_name = data.logical_name;
            column_instance.physical_name = data.physical_name;
        }

        let state_site = STORE.state().get('site');
        if (from=='page03') {
            let page =  state_site.pages.find((d) => { return d.code == 'page03'; });
            page.modal.logical_name.data = null;
        }

        return {
            type: 'SAVED-COLUMN-INSTANCE-LOGICAL-NAME',
            data: {
                er: state_er,
                sige: state_site
            },
            from: from,
            redraw: column_instance ? column_instance._table : null
        };
    }
    saveColumnInstanceDescription (schema_code, column_instance, value, from) {
        let fmt = '/er/%s/columns/instance/%s/description';
        let path = fmt.format(schema_code, column_instance._id);
        let data = { contents: value.trim() };

        API.post(path, data, (resource)=>{
            STORE.dispatch(this.savedColumnInstanceDescription(resource));
        });
    }
    savedColumnInstanceDescription (resource) {
        let state = STORE.get('er');
        let ht = state.column_instances.ht;
        let source = resource;
        let target = ht[source._id];

        target.description = source.description;

        return {
            type: 'SAVED-COLUMN-INSTANCE-DESCRIPTION',
            data: { er: state }
        };
    }
    savePosition (schema, table) {
        let scheme_code = schema.code.toLowerCase();

        let path = '/er/' + scheme_code + '/tables/' + table.code + '/position';
        let data = {x: table.x, y:table.y, z:0};
        API.post(path, data, ()=>{});
    }
    saveTableSize (schema, table) {
        let scheme_code = schema.code.toLowerCase();
        let table_code = table.code.toLowerCase();

        let path = '/er/' + scheme_code + '/tables/' + table_code + '/size';
        let data = {w: table.w, y:table.h};
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
    /* **************************************************************** *
     *  Fetch TER
     * **************************************************************** */
    mergeStateData (source, target) {
        let ht = target.ht;

        for (let obj of source)
            if (ht[obj._id]) {
                ht[obj._id] = obj;
            } else {
                ht[obj._id] = obj;
                target.list.push(obj);
            }

        return target;
    }
    fetchTerEntities (mode) {
        let graph = 'RBP';
        let path = '/ter/%s/entities'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedTerEntities(mode, response));
        }.bind(this));
    }
    fetchedTerEntities (mode, response) {
        let new_state = STORE.get('ter');

        this.mergeStateData(response, new_state.entities);

        return {
            type: 'FETCHED-TER-ENTITIES',
            mode: mode,
            data: {
                ter: new_state,
            }
        };
    }
    fetchTerIdentifiers (mode) {
        let graph = 'RBP';
        let path = '/ter/%s/identifiers'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedTerIdentifiers(mode, response));
        }.bind(this));
    }
    fetchedTerIdentifiers (mode, response) {
        let new_state = STORE.get('ter');

        this.mergeStateData(response, new_state.identifier_instances);

        return {
            type: 'FETCHED-TER-IDENTIFIERS',
            mode: mode,
            data: {
                ter: new_state,
            }
        };
    }
    fetchTerAttributes (mode) {
        let graph = 'RBP';
        let path = '/ter/%s/attributes'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedTerAttributes(mode, response));
        }.bind(this));
    }
    fetchedTerAttributes (mode, response) {
        let new_state = STORE.get('ter');

        this.mergeStateData(response, new_state.attribute_instances);

        return {
            type: 'FETCHED-TER-ATTRIBUTES',
            mode: mode,
            data: {
                ter: new_state,
            }
        };
    }
    fetchTerPorts (mode) {
        let graph = 'RBP';
        let path = '/ter/%s/ports'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedTerPorts(mode, response));
        }.bind(this));
    }
    fetchedTerPorts (mode, response) {
        let new_state = STORE.get('ter');

        return {
            type: 'FETCHED-TER-PORTS',
            mode: mode,
            data: {
                ter: new_state,
            }
        };
    }
    fetchTerEdges (mode) {
        let graph = 'RBP';
        let path = '/ter/%s/edges'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedTerEdges(mode, response));
        }.bind(this));
    }
    fetchedTerEdgesFixData (edges, state) {
        let out = [];
        let keys = {
            'RESOURCE':            'entities',
            'IDENTIFIER-INSTANCE': 'identifier_instances',
            'ATTRIBUTE-INSTANCE':  'attribute_instances',
            'PORT-TER':            'ports',

        };
        let getNode = (node_class, _id) => {
            let key = keys[node_class];

            if (!key)
                throw new Error('対応していない node_class です。 node_class=' + node_class);

            return state[key].ht[_id];
        };

        for (let edge of edges) {
            let from = getNode(edge.from_class, edge.from_id);
            let to   = getNode(edge.to_class,   edge.to_id);

            if (!from || !to)
                continue;

            edge._from = from;
            edge._to   = to;

            out.push(edge);
        }

        return out;
    }
    fetchedTerEdges (mode, response) {
        let new_state   = STORE.get('ter');
        let edges_fixed = this.fetchedTerEdgesFixData(response, new_state);

        this.mergeStateData(edges_fixed, new_state.relationships);

        return {
            type: 'FETCHED-TER-EDGES',
            mode: mode,
            data: {
                ter: new_state,
            }
        };
    }
    /* **************************************************************** *
     *  Inspector
     * **************************************************************** */
    setDataToInspector (data) {
        let data_old = STORE.state().get('inspector').data;
        let data_new = data;

        if (data_old!=null && data_new._id == data_old._id)
            data_new = null;


        let display = true;
        if (data_new==null)
            display = false;

        return {
            type: 'SET-DATA-TO-INSPECTOR',
            data: {
                inspector: {
                    data: data_new,
                    display: display
                }
            }
        };
    }
    /* **************************************************************** *
     *  Svg
     * **************************************************************** */
    closeAllSubPanels () {
        let state = STORE.state().toJS();
        let inspector = state.inspector;
        let global = state.global;
        let data = {};

        if (inspector.display) {
            inspector.display = false;
            data.inspector = inspector;
        }

        if (global.menu.move_panel.open) {
            global.menu.move_panel.open = false;
            data.global = global;
        }

        return {
            type: 'CLOSE-ALL-SUB-PANELS',
            data: data
        };
    }
    /* **************************************************************** *
     *  Grobal menu
     * **************************************************************** */
    toggleMovePagePanel () {
        let state = STORE.state().get('global');
        state.menu.move_panel.open = !state.menu.move_panel.open;
        return {
            type: 'TOGGLE-MOVE-PAGE-PANEL',
            data: {
                global: state
            }
        };
    }
    /* **************************************************************** *
     *  Snapshot
     * **************************************************************** */
    snapshotAll () {
        let x = '/rpc/snapshot/all';

        API.get('/rpc/snapshot/all', (response) => {
        });

    }
    /* **************************************************************** *
     *  Page03
     * **************************************************************** */
    setDataToModalLogicalName (page_code, data) {
        let site = STORE.state().get('site');
        let page = site.pages.find((d) => { return d.code == page_code; });

        page.modal.logical_name.data = data;

        return {
            type: 'SET-DATA-TO-MODAL-LOGICAL-NAME',
            data: { site: site }
        };
    }
}
