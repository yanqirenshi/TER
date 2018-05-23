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
    fetchErEntities () {
        API.get('/er/entities', function (response) {
            STORE.dispatch(this.fetchedErEntities(response));
        }.bind(this));
    }
    fetchedErEntities (response) {
        let state_er = STORE.state().get('er');
        state_er.entities = this.makeGraphData(response);
        return {
            type: 'FETCHED-ER-ENTITIES',
            data: { er: state_er }
        };
    }
    fetchErAttributes () {
        API.get('/er/attributes', function (response) {
            STORE.dispatch(this.fetchedErAttributes(response));
        }.bind(this));
    }
    fetchedErAttributes (response) {
        let state_er = STORE.state().get('er');
        state_er.attributes = this.makeGraphData(response);
        return {
            type: 'FETCHED-ER-ATTRIBUTES',
            data: { er: state_er }
        };
    }
    fetchErAttributeEntitis () {
        API.get('/er/attribute-entitis', function (response) {
            STORE.dispatch(this.fetchedErAttributeEntitis(response));
        }.bind(this));
    }
    fetchedErAttributeEntitis (response) {
        let state_er = STORE.state().get('er');
        state_er.attribute_entitis = this.makeGraphData(response);
        return {
            type: 'FETCHED-ER-ATTRIBUTE-ENTITIS',
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
