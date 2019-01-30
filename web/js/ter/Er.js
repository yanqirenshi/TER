class Er {
    constructor (options) {
        this._table = null;
        this._callbacks = options.callbacks;
    }
    // Common
    random (v, type) {
        let min;
        let max;

        if (type=='x') {
            min = 11;
            max = v - 11;
        }
        if (type=='y') {
            min = 11;
            max = v * 2 - 11;
        }
        return Math.floor( Math.random() * (max + 1 - min) ) + min ;
    }
    // ER
    clear (d3svg) {
        if (!this._table) this._table = new Table({ d3svg:d3svg });

        this._table.removeAll();
    }
    drawTables (d3svg, state) {
        if (!this._table)
            this._table = new Table({
                d3svg:d3svg,
                callbacks: this._callbacks.table,
            });

        let tables = state.tables.list;

        this._table.draw(tables);
    }
    reDrawTable (table) {
        if (table)
            this._table.reDraw(table);
    }
}
