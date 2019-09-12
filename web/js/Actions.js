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
    fetchGraph (mode) {
        API.get('/graph', function (response) {
            STORE.dispatch(this.fetchedGraph(mode, response));
        }.bind(this));
    }
    fetchedGraph (mode, response) {
        let dm = new ErDataManeger();

        return {
            type: 'FETCHED-GRAPH',
            mode: mode,
            data: {
                graph: {
                    nodes: dm.makeGraphData(response.NODES),
                    edges: dm.makeGraphData(response.EDGES),
                }
            }
        };
    }
    /* **************************************************************** *
     *  Fetch ER
     * **************************************************************** */
    fetchErNodes (schema, mode) {
        let scheme_code = schema.code.toLowerCase();

        API.get('/er/' + scheme_code + '/nodes', function (response) {
            STORE.dispatch(this.fetchedErNodes(mode, response));
        }.bind(this));
    }
    fetchedErNodes (mode, response) {
        return {
            type: 'FETCHED-ER-NODES',
            mode: mode,
            data: {
                er: new ErDataManeger().responseNode2Data(response),
            }
        };
    }
    fetchErEdges (schema, mode) {
        let scheme_code = schema.code.toLowerCase();

        API.get('/er/' + scheme_code + '/edges', function (response) {
            STORE.dispatch(this.fetchedErEdges(mode, response));
        }.bind(this));
    }
    fetchedErEdges (mode, response) {
        let new_state        = STORE.state().get('er');

        // TODO: response つこてないんじゃけど。
        new_state.edges = new ErDataManeger().responseEdge2Data(
            new_state.relashonships,
            new_state.ports);

        if (mode=='FIRST')
            new_state.first_loaded = true;

        return {
            type: 'FETCHED-ER-EDGES',
            mode: mode,
            data: { er: new_state }
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

        let post_data = { logical_name: data.logical_name };

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

        let data = { w: table.w, h: 0 };

        API.post(path, data, ()=>{});
    }
    saveErCameraLookAt (schema, camera, look_at) {
        let _look_at = Object.assign({}, look_at);
        let path = '/er/schemas/%s/camera/%s/look-at'.format(schema.code, camera.code);
        let data = {
            x: _look_at.x || 0,
            y: _look_at.y || 0,
            z: _look_at.z || 0
        };
        API.post(path, data, ()=>{});
    }
    saveErCameraLookMagnification (schema, camera, magnification) {
        let path = '/er/schemas/%s/camera/%s/magnification'.format(schema.code, camera.code);

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
    fetchTerEnvironment (schema, mode) {
        let graph = schema;
        let path = '/ter/%s/environment'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedTerEnvironment(schema, mode, response));
        }.bind(this));
    }
    fetchedTerEnvironment (schema, mode, response) {
        let new_state = STORE.get('ter');

        new_state.cameras = new TerDataManeger().mergeStateData(response.cameras, new_state.cameras);

        let cameras = new_state.cameras.list;
        new_state.camera = cameras.length==0 ? null : cameras[0];

        return {
            type: 'FETCHED-TER-ENVIRONMENT',
            data: {
                ter:  new_state,
            },
            schema: schema,
            mode: mode,
        };
    }
    fetchTerEntities (schema, mode) {
        let graph = schema;
        let path = '/ter/%s/entities'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedTerEntities(schema, mode, response));
        }.bind(this));
    }
    fetchedTerEntities (schema, mode, response) {
        let new_state = STORE.get('ter');

        new_state.entities = new TerDataManeger().mergeStateData(response, new_state.entities);

        return {
            type: 'FETCHED-TER-ENTITIES',
            schema: schema,
            mode: mode,
            data: {
                ter: new_state,
            }
        };
    }
    fetchTerIdentifiers (schema, mode) {
        let graph = schema;
        let path = '/ter/%s/identifiers'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedTerIdentifiers(schema, mode, response));
        }.bind(this));
    }
    fetchedTerIdentifiers (schema, mode, response) {
        let new_state = STORE.get('ter');

        new_state.identifier_instances = new TerDataManeger().mergeStateData(response, new_state.identifier_instances);

        return {
            type: 'FETCHED-TER-IDENTIFIERS',
            schema: schema,
            mode: mode,
            data: {
                ter: new_state,
            }
        };
    }
    fetchTerAttributes (schema, mode) {
        let graph = schema;
        let path = '/ter/%s/attributes'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedTerAttributes(schema, mode, response));
        }.bind(this));
    }
    fetchedTerAttributes (schema, mode, response) {
        let new_state = STORE.get('ter');

        new_state.attribute_instances = new TerDataManeger().mergeStateData(response, new_state.attribute_instances);

        return {
            type: 'FETCHED-TER-ATTRIBUTES',
            schema: schema,
            mode: mode,
            data: {
                ter: new_state,
            }
        };
    }
    fetchTerPorts (schema, mode) {
        let graph = schema;
        let path = '/ter/%s/ports'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedTerPorts(schema, mode, response));
        }.bind(this));
    }
    fetchedTerPorts (schema, mode, response) {
        let new_state = STORE.get('ter');

        new_state.ports = new TerDataManeger().mergeStateData(response, new_state.ports);

        return {
            type: 'FETCHED-TER-PORTS',
            schema: schema,
            mode: mode,
            data: {
                ter: new_state,
            }
        };
    }
    fetchTerEdges (schema, mode) {
        let graph = schema;
        let path = '/ter/%s/edges'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedTerEdges(schema, mode, response));
        }.bind(this));
    }
    fetchedTerEdges (schema, mode, response) {
        let new_state   = STORE.get('ter');

        new_state.relationships = new TerDataManeger().mergeStateData(response, new_state.relationships);

        return {
            type: 'FETCHED-TER-EDGES',
            schema: schema,
            mode: mode,
            data: {
                ter: new_state,
            }
        };
    }
    fetchedAllDatas (mode) {
        let new_state   = STORE.get('ter');

        new TerDataManeger().state2state(new_state);

        if (mode=='FIRST')
            new_state.first_loaded = true;

        STORE.dispatch({
            type: 'FETCHED-ALL-DATAS',
            mode: mode,
            data: {
                ter: new_state,
            }
        });
    }
    saveTerEntityPosition (schema, entity) {
        let path = '/ter/%s/entities/%d/location'.format(schema.code, entity._id);

        let data = entity.position;
        API.post(path, data, ()=>{});
    }
    saveTerPortPosition (schema, port, position) {
        let path = "/ter/%s/ports/%d/location".format(schema.code, port._id);
        let post_data = { degree: position };

        API.post(path, post_data, (response)=>{
            STORE.dispatch(this.savedTerPortPosition(response));
        });
    }
    savedTerPortPosition (response) {
        let new_state = STORE.get('ter');

        new_state.ports = new TerDataManeger().mergeStateData([response], new_state.ports);

        return {
            type: 'SAVED-TER-PORT-POSITION',
            data: {
                ter: new_state,
            },
            target: response,
        };
    }
    saveTerCameraLookAt (schema, camera, position) {
        let path = '/ter/%s/cameras/%s/look-at'.format(schema.code, camera.code);

        let post_data = {
            x: position.x || 0,
            y: position.y || 0,
            z: position.z || 0
        };

        API.post(path, post_data, ()=>{});
    }
    saveTerCameraLookMagnification (schema, camera, magnification) {
        let path = '/ter/%s/cameras/%s/magnification'.format(schema.code, camera.code);
        let post_data = {
            magnification: magnification || 1
        };

        API.post(path, post_data, ()=>{});
    }
    /* **************************************************************** *
     *  Inspector
     * **************************************************************** */
    setDataToInspector (data) {
        let data_old = STORE.state().get('inspector').data;
        let data_new = data;

        if (data_new && data_old && data_new._id == data_old._id)
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
    /* **************************************************************** *
     *  Modal
     * **************************************************************** */
    openModalCreateSystem () {
        let state = STORE.get('modals');

        state['create-system'] = {
            code: '',
            name: '',
            description: '',
        };

        STORE.dispatch({
            type: 'OPEN-MODAL-CREATE-SYSTEM',
            data: { modals: state },
        });
    }
    closeModalCreateSystem () {
        let state = STORE.get('modals');

        state['create-system'] = null;

        STORE.dispatch({
            type: 'CLOSE-MODAL-CREATE-SYSTEM',
            data: { modals: state },
        });
    }
    /* **************************************************************** *
     *  System
     * **************************************************************** */
    createSystem (data) {
        let path = '/system';
        let post_data = data;

        API.post(path, post_data, function (response) {
            STORE.dispatch(this.createdSystem(response));
        }.bind(this));
    }
    createdSystem (response) {
        return {
            type: 'CREATED-SYSTEM',
            data: {},
        };
    }
}
