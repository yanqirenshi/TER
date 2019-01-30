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
        if (!this._table) this._table = new ErTable({ d3svg:d3svg });

        this._table.removeAll();
    }
    drawEdges (d3svg) {
        let svg = d3svg._svg;

        this._Edge = new Edge();
        this._Edge.draw(svg, STORE.state().get('er').edges.list);
    }
    moveEdges (d3svg, tables) {
        let svg = d3svg._svg;

        this._Edge = new Edge();
        this._Edge.moveEdges(svg, ([[]].concat(tables)).reduce((a,b) => {
            return b._edges ? a.concat(b._edges) : a;
        }));
    }
    drawTablesCore (d3svg, state) {
        if (!this._table)
            this._table = new ErTable({
                d3svg:d3svg,
                callbacks: this._callbacks.table,
            });

        let tables = state.tables.list;
        this._table.draw(tables);

        return tables;
    }
    drawTables (d3svg, state) {
        this.drawEdges(d3svg);

        let tables = this.drawTablesCore(d3svg, state);

        this.moveEdges(d3svg, tables);
    }
    reDrawTable (table) {
        if (table)
            this._table.reDraw(table);
    }
}
