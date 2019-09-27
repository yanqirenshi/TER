class Actions extends Vanilla_Redux_Actions {
    movePage (data) {
        let state = STORE.get('site');

        // Page は選択された route の根なので "[0]" を指定。
        state.active_page = data.route[0];

        STORE.dispatch({
            type: 'MOVE-PAGE',
            data: { site: state },
            route: data.route,
        });
    }
    list2Pool (list) {
        if (!list)
            return { ht: {}, list: [] };

        let pool = { ht: {}, list: list };

        for (let obj of list)
            pool.ht[obj._id] = obj;

        return pool;
    }
    /* **************************************************************** *
     *  Save Config
     * **************************************************************** */
    /* **************************************************************** *
     *  Fetch Environment
     * **************************************************************** */
    fetchEnvironments (mode) {
        API.get('/environments', function (response) {
            STORE.dispatch(this.fetchedEnvironments(mode, response));
        }.bind(this));
    }
    fetchedEnvironments (mode, response) {
        let state = STORE.get('active');

        let getActiveSystem = () => {
            let active_system = null;

            let id = response.active.system;

            if (id)
                active_system = response.systems.find((d) => {
                    return d._id == id;
                });

            if (active_system)
                return active_system;

            if (response.systems.length==0)
                return null;

            return response.systems[0];
        };

        let getActiveElement = (list, id) => {
            if (list.length==0)
                return null;

            let active_element;

            if (id)
                active_element = list.find((d) => {
                    return d._id == id;
                });

            if (active_element)
                return active_element;

            return list[0];
        };

        if (response.systems.length!=0) {
            let active_system = getActiveSystem();

            state.system = active_system;

            state.ter.campus = getActiveElement(active_system.campuses, response.active.ter.campus);
            state.er.schema = getActiveElement(active_system.schemas,  response.active.er.schema);
        }

        return {
            type: 'FETCHED-ENVIRONMENTS',
            mode: mode,
            data: {
                modeler: response.modeler,
                systems: this.list2Pool(response.systems),
                active: state,
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
    fetchErEnvironment (schema, mode) {
        let graph = schema;
        let path = '/er/%s/environments'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedErEnvironment(schema, mode, response));
        }.bind(this));
    }
    fetchedErEnvironment (schema, mode, response) {
        let new_state = STORE.get('er');

        let ht = {};
        for (let schema of response.schemas) {
            for (let data of schema.cameras) {
                let camera = data.camera;
                ht[camera._id] = camera;
            }
        }
        let list = [];
        for (let key in ht)
            list.push(ht[key]);

        new_state.system  = response.system;
        new_state.schema  = response.schema;
        new_state.schemas = new TerDataManeger().mergeStateData(response.schemas, new_state.schemas);
        new_state.cameras = new TerDataManeger().mergeStateData(list, new_state.cameras);

        let cameras = new_state.cameras.list;
        new_state.camera = cameras.length==0 ? null : cameras[0];

        return {
            type: 'FETCHED-ER-ENVIRONMENT',
            data: {
                er:  new_state,
            },
            schema: schema,
            mode: mode,
        };
    }
    fetchErNodes (schema, mode) {
        let scheme_code = schema.code.toLowerCase();

        API.get('/er/' + scheme_code + '/nodes', function (response) {
            STORE.dispatch(this.fetchedErNodes(mode, response));
        }.bind(this));
    }
    fetchedErNodes (mode, response) {
        let new_state = STORE.get('er');

        return {
            type: 'FETCHED-ER-NODES',
            mode: mode,
            data: {
                er: new ErDataManeger().responseNode2Data(response, new_state),
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
        let new_state = STORE.get('er');

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
    changeSystem (system) {

        let state = STORE.get('active');

        state.system = system;

        if (system.campuses.length!=0)
            state.ter.campus = system.campuses[0];

        if (system.schemas.length!=0)
            state.er.schema = system.schemas[0];

        this.saveConfigAtDefaultSystem(system);

        STORE.dispatch({
            type: 'CHANGE-SYSTEM',
            data: { active: state },
        });
    }
    saveConfigAtDefaultSystem (system) {
        let path = '/systems/%d/active'.format(system._id);

        API.post(path, null, (response) => {
            STORE.dispatch(this.savedConfigAtDefaultSystem(response));
        });
    }
    savedConfigAtDefaultSystem (response) {
        return {
            type: 'SAVED-CONFIG-AT-DEFAULT-SYSTEM',
        };
    }
    /* **************************************************************** *
     *  Fetch TER
     * **************************************************************** */
    fetchTerEnvironment (schema, mode) {
        let graph = schema;
        let path = '/ter/%s/environments'.format(graph);

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedTerEnvironment(schema, mode, response));
        }.bind(this));
    }
    fetchedTerEnvironment (schema, mode, response) {
        let new_state = STORE.get('ter');

        let ht = {};
        for (let campus of response.campuses) {
            for (let data of campus.cameras) {
                let camera = data.camera;
                ht[camera._id] = camera;
            }
        }
        let list = [];
        for (let key in ht)
            list.push(ht[key]);

        new_state.system   = response.system;
        new_state.campus   = response.campus;
        new_state.campuses = new TerDataManeger().mergeStateData(response.campuses, new_state.campuses);
        new_state.cameras  = new TerDataManeger().mergeStateData(list, new_state.cameras);

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

        STORE.dispatch({
            type: 'TOGGLE-MOVE-PAGE-PANEL',
            data: {
                global: state
            }
        });
    }
    openGlobalMenuSystemPanel () {
        let state = STORE.state().get('global');

        state.menu.move_panel.open = true;

        STORE.dispatch({
            type: 'OPEN-GLOBAL-MENU-SYSTEM-PANEL',
            data: { global: state },
        });
    }
    closeGlobalMenuSystemPanel () {
        let state = STORE.state().get('global');

        state.menu.move_panel.open = false;

        STORE.dispatch({
            type: 'CLOSE-GLOBAL-MENU-SYSTEM-PANEL',
            data: { global: state },
        });
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
    openModalCreateEntity () {
        let state = STORE.get('modals');

        state['create-entity'] = {
            type: '',
            code: '',
            name: '',
            description: '',
        };

        STORE.dispatch({
            type: 'OPEN-MODAL-CREATE-ENTITY',
            data: { modals: state },
        });
    }
    closeModalCreateEntity () {

        let state = STORE.get('modals');

        state['create-entity'] = null;

        STORE.dispatch({
            type: 'CLOSE-MODAL-CREATE-ENTITY',
            data: { modals: state },
        });
    }
    /* **************************************************************** *
     *  System
     * **************************************************************** */
    createSystem (data) {
        let path = '/systems';
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
    createTerEntity (data) {
        let path = '/systems/:code/campus/:code/entities';
        let post_data = data;

        API.post(path, post_data, function (response) {
            STORE.dispatch(this.createdTerEntity(response));
        }.bind(this));
    }
    createdTerEntity (response) {
        return {
            type: 'CREATED-SYSTEM',
            data: {},
        };
    }
    /* **************************************************************** *
     *  Page
     * **************************************************************** */
    fetchPagesManagements () {
        let path = '/pages/managements';

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedPagesManagements(response));
        }.bind(this));
    }
    fetchedPagesManagements (response) {
        return {
            type: 'FETCHED-PAGES-MANAGEMENTS',
            response: response,
        };
    }
    fetchPagesSystems () {
        let path = '/pages/systems';

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedPagesSystems(response));
        }.bind(this));
    }
    fetchedPagesSystems (response) {
        return {
            type: 'FETCHED-PAGES-SYSTEMS',
            response: response,
        };
    }
    fetchPagesSystem (id) {
        let path = '/pages/systems/' + id;

        API.get(path, function (response) {
            STORE.dispatch(this.fetchedPagesSystem(response));
        }.bind(this));
    }
    fetchedPagesSystem (response) {
        return {
            type: 'FETCHED-PAGES-SYSTEM',
            response: response,
        };
    }
}
