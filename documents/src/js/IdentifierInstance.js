import ColumnInstance from './ColumnInstance.js';

export default class IdentifierInstance extends ColumnInstance {
    template () {
        return {
            _id: null,
            _class: 'IDENTIFIER-INSTANCE',
            name: { physical: '??', logical: '' },
            position: { x: 0, y:0 },
            size: { w:0, h:0 },
            _master: null,
            _core: null,
            _ports: [],
        };
    }
}
