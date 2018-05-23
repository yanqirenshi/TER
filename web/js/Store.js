class Store extends Vanilla_Redux_Store {
    constructor(reducer) {
        super(reducer, null);
    }
    init () {
        this._contents = Immutable.Map({
            pages: {
                page01: {},
                page02: {},
                page03: {}
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
