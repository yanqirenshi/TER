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
                entities:          {ht: {}, list: []},
                attributes:        {ht: {}, list: []},
                attribute_entitis: {ht: {}, list: []},
                relashonships:     {ht: {}, list: []}
            }
        });
        return this;
    }
}
