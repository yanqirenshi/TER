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
                    active: response.SCHEMAS[1]._id,
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
    fetchedEr (mode, response) {
        return {
            type: 'FETCHED-ER',
            mode: mode,
            data: {
                er: {
                    tables:           this.makeGraphData(response.TABLES),
                    columns:          this.makeGraphData(response.COLUMNS),
                    column_instances: this.makeGraphData(response.COLUMN_INSTANCES),
                    relashonships:    this.makeGraphData(response.RELASHONSHIPS),
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
}
