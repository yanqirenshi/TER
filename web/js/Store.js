class Store extends Vanilla_Redux_Store {
    constructor(reducer) {
        super(reducer, null);
    }
    init () {
        this._contents = Immutable.Map({
            pages: {
                'GRAPH': {
                    code: 'GRAPH',
                    active: true
                },
                'TER': {
                    code: 'TER',
                    active: false
                },
                'ER': {
                    code: 'ER',
                    active: false
                }
            },
            er: {
                tables:           {ht: {}, list: []},
                columns:          {ht: {}, list: []},
                column_instances: {ht: {}, list: []},
                relashonships:    {ht: {}, list: []}
            }
        });
        return this;
    }
}
