export default class Port {
    constructor() {
        this.position = { x:0, y:0 };

        this._id      = null;
        this._class   = null;

        this._core    = null;

        this._entity  = null;
    }
    template () {
        return {
            _id: null,
            _class: null,
            position: { x:0, y:0 },
            _position: null,
            _entity: null,
        };
    }
    build (type, position, idenrifier_instance) {
        let element = this.template();

        element._id = idenrifier_instance._id;
        element._class = type==='from' ? 'PORT-FROM' : 'PORT-TO';

        element._idenrifier_instance = idenrifier_instance;

        if (position)
            element._position = position;

        idenrifier_instance._ports.push(element);

        return element;
    }
}
