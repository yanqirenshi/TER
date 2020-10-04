import Pool from './Pool.js';

export default class Attribute {
    list2pool (list) {
        return new Pool().list2pool (list, (d) => {
            return d;
        });
    }
    template () {
        return {
            _id: null,
            _class: 'ATTRIBUTE',
            name: { physical: '??', logical: '' },
            _core: null,
        };
    }
    build (core) {
        let element = this.template();

        element._id = core.id;
        element.name = core.name;

        element._core = core;
        core._element = element;

        return element;
    }
}
