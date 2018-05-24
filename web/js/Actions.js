class Actions extends Vanilla_Redux_Actions {
    movePage (data) {
        return {
            type: 'MOVE-PAGE',
            data: data
        };
    }
    /* **************************************************************** *
       ER
     * **************************************************************** */
    makeGraphData (list) {
        let ht = {};
        for (var i in list) {
            let data = list[i];
            ht[data._id] = data;
        }
        return {ht: ht, list: list};
    }
    fetchEr () {
        API.get('/er', function (response) {
            STORE.dispatch(this.fetchedEr(response));
        }.bind(this));
    }
    fetchedEr (response) {
        return {
            type: 'FETCHED-ER',
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
}
