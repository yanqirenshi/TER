import Pool from './Pool.js';

export default class Relationship {
    constructor() {
        this.i = 100000000;
    }
    list2pool (list) {
        let pool = new Pool().list2pool (list, (d) => {
            return d;
        });

        pool.indexes ={
            from: {},
            to: {},
        };

        return pool;
    }
    template () {
        return {
            _id: null,
            _class: 'RELATIONSHIP',
            from: null,
            to: null,
        };
    }
    build (core, port_from, port_to) {
        let element = this.template();

        element._id = this.i++;

        element.from = port_from;
        element.to = port_to;

        port_from._relationship = element;
        port_to._relationship   = element;

        element._core = core;
        core._element = element;

        return element;
    }
}
