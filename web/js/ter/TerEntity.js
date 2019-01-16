class TerEntity {
    constructor() {
        this._id = null;
        this._class = null;
        this._core = null;

        this.this.description = { contents: '' };

        this.position = { x:0, y:0, z:0 };

        this.size = { w:0, h:0 };

        this.padding = 11;
        this.margin = 6;

        this.bar = {
            size: {
                header: 11,
                contents: 8,
            }
        };

        this.background = {
            color: '',
        };

        this.name = {
            position: { x:0, y:0, z:0 },
            size: { h: null, w: null },
            padding: 11,
            contents: ''
        };

        this.type = {
            position: { x:0, y:0, z:0 },
            size: { h: null, w: 42 },
            padding: 11,
            size: { w:0, h:0 },
        };

        this.identifiers = {
            position: { x:0, y:0, z:0 },
            padding: 8, // 各項目の一辺の padding 値
            size: { w: null, h: null },
            items: { list: [], ht: {} },
        };

        this.attributes = {
            position: { x:0, y:0, z:0 },
            padding: 8, // 各項目の一辺の padding 値
            size: { w: null, h: null },
            items: { list: [], ht: {} },
        };

        this.ports = {
            items: { list: [], ht: {} },
        };

    }
}
