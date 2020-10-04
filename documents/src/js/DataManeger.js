export default class DataManeger {
    mergeStateDataObject (source, target) {
        if (source._id!=target._id)
            throw new Error('not eq object');

        for (let key in source)
            target[key] = source[key];
    }
    mergeStateData (source, target) {
        let new_target = {
            ht: Object.assign({}, target.ht),
            list: target.list.slice(),
        };

        if (target.indexes) {
            new_target.indexes = {
                from: Object.assign({}, target.indexes.from),
                to:   Object.assign({}, target.indexes.to),
            };
        }


        let ht = new_target.ht;
        for (let obj of source)
            if (ht[obj._id]) {
                this.mergeStateDataObject(obj, ht[obj._id]);
            } else {
                ht[obj._id] = obj;
                new_target.list.push(obj);
            }

        return new_target;
    }
    /**
     * relationship の _from と _to に値をセットします。
     */
    fixEdgesData (state) {
        let out = [];
        let edges = state.relationships.list;
        let keys = {
            'RESOURCE':            'entities',
            'RESOURCE-SUBSET':     'entities',
            'EVENT':               'entities',
            'EVENT-SUBSET':        'entities',
            'COMPARATIVE':         'entities',
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
    /**
     * Relationship の index を作成します。
     */
    injectEdgeData (edges, new_state) {
        for (let edge of edges) {
            let index_from = new_state.relationships.indexes.from;
            let index_to   = new_state.relationships.indexes.to;

            if (!index_from[edge.from_id]) index_from[edge.from_id] = {};
            if (!index_to[edge.to_id])     index_to[edge.to_id]     = {};

            index_from[edge.from_id][edge._id] = edge;
            index_to[edge.to_id][edge._id]     = edge;
        }
    }
    /**
     * API で取得した response で作成した state もどきを、正式な state に変換する。たぶん
     * これは responses2state がイケてる気がする。
     */
    state2state(new_state) {
        let edges_fixed = this.fixEdgesData(new_state);

        this.injectEdgeData(edges_fixed, new_state);
    }
    /**
     * Json でロードしたデータを state に変換する。
     */
    json2state(json) {
        let pool = { ht: {}, list: [] };
        let pool_relationships = Object.assign({}, pool, { indexes: { from: {}, to: {} } });
        let state = {
            camera:               json.cameras,
            entities:             this.mergeStateData(json.entities,             pool),
            relationships:        this.mergeStateData(json.relationships,        pool_relationships),
            ports:                this.mergeStateData(json.ports,                pool),
            identifier_instances: this.mergeStateData(json.identifier_instances, pool),
            attribute_instances:  this.mergeStateData(json.attribute_instances,  pool),
        };

        this.injectEdgeData(this.fixEdgesData(state), state);

        return state;
    }
};
