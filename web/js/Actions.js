class Actions extends Vanilla_Redux_Actions {
    movePage (data) {
        return {
            type: 'MOVE-PAGE',
            data: data
        };
    }
    fetchData () {
        API.get('/', function (response) {
            STORE.dispatch(this.fetchedData(response));
        }.bind(this));
    }
    fetchedData (response) {
        return {
            type: 'FETCHED-DATA',
            data: response,
            target: 'stage'
        };
    }
    fetchErEntities () {
        API.get('/er/entities', function (response) {
            STORE.dispatch(this.fetchedErEntities(response));
        }.bind(this));
    }
    fetchedErEntities (response) {
        return {
            type: 'FETCHED-ER-ENTITIES',
            data: response,
            target: 'stage'
        };
    }
    fetchErAttributes () {
        API.get('/er/attributes', function (response) {
            STORE.dispatch(this.fetchedErAttributes(response));
        }.bind(this));
    }
    fetchedErAttributes (response) {
        return {
            type: 'FETCHED-ER-ATTRIBUTES',
            data: response,
            target: 'stage'
        };
    }
    fetchErAttributeEntitis () {
        API.get('/er/attribute-entitis', function (response) {
            STORE.dispatch(this.fetchedErAttributeEntitis(response));
        }.bind(this));
    }
    fetchedErAttributeEntitis (response) {
        return {
            type: 'FETCHED-ER-ATTRIBUTE-ENTITIS',
            data: response,
            target: 'stage'
        };
    }
    fetchErRelashonships () {
        API.get('/er/relashonships', function (response) {
            STORE.dispatch(this.fetchedErRelashonships(response));
        }.bind(this));
    }
    fetchedErRelashonships (response) {
        return {
            type: 'FETCHED-ER-RELASHONSHIPS',
            data: response,
            target: 'stage'
        };
    }
}
