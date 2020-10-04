import Pool from './Pool.js';

export default class ColumnInstance {
    list2pool (list) {
        return new Pool().list2pool(list);
    }
    template () {
        return {
            _id: null,
            _core: null,
            _master: null,
            name: null,
        };
    }
    build (core, master) {
        let element = this.template();

        element._id = core.id;

        element._core = core;
        core._element = element;

        element._master = master;

        element.name = {...(core.name ? core.name : master.name)};

        return element;
    }
}
