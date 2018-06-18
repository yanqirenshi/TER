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
                schema: response.SCHEMA,
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
    fetchEr (mode) {
        API.get('/er/rbr', function (response) {
            STORE.dispatch(this.fetchedEr(mode, response));
        }.bind(this));
    }
    fetchedEr (mode, response) {
        return {
            type: 'FETCHED-ER',
            mode: mode,
            data: {
                er: {
                    tables:           this.makeGraphData(response.TABLES),
                    columns:          this.makeGraphData(response.COLUMNS),
                    column_instances: this.makeGraphData(response.COLUMN_INSTANCES),
                    relashonships:    this.makeGraphData(response.RELASHONSHIPS)
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
    fetchErTables () {
        API.get('/er/tables', function (response) {
            STORE.dispatch(this.fetchedErTables(response));
        }.bind(this));
    }
    fetchedErTables (response) {
        let state_er = STORE.state().get('er');
        state_er.tables = this.makeGraphData(response);
        return {
            type: 'FETCHED-ER-TABLES',
            data: { er: state_er }
        };
    }
    fetchErColumns () {
        API.get('/er/columns', function (response) {
            STORE.dispatch(this.fetchedErColumns(response));
        }.bind(this));
    }
    fetchedErColumns (response) {
        let state_er = STORE.state().get('er');
        state_er.columns = this.makeGraphData(response);
        return {
            type: 'FETCHED-ER-COLUMNS',
            data: { er: state_er }
        };
    }
    fetchErColumnInstances () {
        API.get('/er/column-instances', function (response) {
            STORE.dispatch(this.fetchedErColumnInstances(response));
        }.bind(this));
    }
    fetchedErColumnInstances (response) {
        let state_er = STORE.state().get('er');
        state_er.column_instances = this.makeGraphData(response);
        return {
            type: 'FETCHED-ER-COLUMN-INSTANCES',
            data: { er: state_er }
        };
    }
    fetchErRelashonships () {
        API.get('/er/relashonships', function (response) {
            STORE.dispatch(this.fetchedErRelashonships(response));
        }.bind(this));
    }
    fetchedErRelashonships (response) {
        let state_er = STORE.state().get('er');
        state_er.relashonships = this.makeGraphData(response);
        return {
            type: 'FETCHED-ER-RELASHONSHIPS',
            data: { er: state_er }
        };
    }
    savePosition (table) {
        let path = '/er/tables/' + table.code + '/position';
        let data = {x: table.x, y:table.y, z:0};
        API.post(path, data, ()=>{});
    }
}
