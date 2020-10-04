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
            _core: null,
            _entity: null,
        };
    }
    build (idenrifier_instance, type) {
        let element = this.template();

        element._id = idenrifier_instance.id;
        element._class = type==='from' ? 'PORT-FROM' : 'PORT-TO';

        element._idenrifier_instance = idenrifier_instance;

        idenrifier_instance._ports.push(element);

        return element;
    }
}
