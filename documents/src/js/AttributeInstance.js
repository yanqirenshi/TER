import ColumnInstance from './ColumnInstance.js';

export default class AttributeInstance extends ColumnInstance {
    template () {
        return {
            _id: null,
            _class: 'ATTRIBUTE-INSTANCE',
            name: { physical: '??', logical: '' },
            position: { x: 0, y:0 },
            size: { w:0, h:0 },
            _master: null,
            _core: null,
        };
    }
}
