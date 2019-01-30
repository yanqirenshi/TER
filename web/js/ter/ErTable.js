class ErTable {
    constructor(options) {
        this._d3svg = options.d3svg;
        this._padding = 11;

        this._TableColumn = new TableColumn({ padding: this._padding });
        this._Edge = new Edge();
        this._Port = new Port();

        this._callbacks = options.callbacks;
    }
    /* **************************************************************** *
     *  util
     * **************************************************************** */
    getCallbak (keys_str) {
        if (!this._callbacks || !keys_str)
            return null;

        let keys = keys_str.split('.');
        let callbacks = this._callbacks;
        for (let key of keys) {
            let val = callbacks[key];
            if (typeof val == "function")
                return val;
            callbacks = val;
        }
        return null;
    }
    callCallbak (thisArg, keys_str) {
        let args_arr = Array.prototype.slice.call(arguments);
        let argsArray = args_arr.slice(2);

        let callback = this.getCallbak(keys_str);

        if (!callback)
            return;

        callback.apply(thisArg, argsArray);
    }
    /* **************************************************************** *
     *  Data manegement
     * **************************************************************** */
    ///
    /// 未実装
    ///
    /* **************************************************************** *
     *  Sizing
     * **************************************************************** */
    headerWidth (d) {
        let padding = this._padding;
        return d.w - padding * 2;
    }
    headerContentsHight (d) {
        return 22;
    }
    headerHight (d) {
        let padding_top = this._padding;
        let padding_bottm = 3;
        return 22 + padding_top + padding_bottm;
    }
    /// base
    baseHeight (d) {
        return this.headerHight(d) + this._TableColumn.columnsHeight(d);
    }
    /* **************************************************************** *
     *  Positioning
     * **************************************************************** */
    ///
    /// 未実装
    ///
    /* **************************************************************** *
     *  Draw ※これはインスタンスメソッドより、クラスメソッド的な。
     * **************************************************************** */
    removeAll () {
        let svg = this._d3svg._svg;

        this._Edge.removeEdgeAll(svg);
        this.removeGAll(svg);
    }
    removeGAll (svg) {
        svg.selectAll('g.table')
            .data([], (d) => { return d._id; })
            .exit()
            .remove();
    }
    drawHeader (g) {
        let padding = this._padding;
        let self = this;
        g.append('rect')
            .attr('class', 'header')
            .attr('x', function (d) { return padding; })
            .attr('y', function (d) { return padding; })
            .attr('width',  (d) => { return this.headerWidth(d); })
            .attr('height', (d) => { return this.headerContentsHight(d); })
            .attr('fill', '#fefefe');

        let resize_tables = this.resize_tables;

        g.append('text')
            .attr('class', 'header')
            .attr('x', function (d) { return padding + 6; })
            .attr('y', function (d) { return padding + 16; })
            .attr('font-size', 16 + 'px')
            .text((d) => { return d.name; })
            .each(function (d) {
                let w = Math.ceil(this.getBBox().width) + padding * 4;
                let table = d;

                if (!resize_tables[table._id])
                    resize_tables[table._id] = {
                        table: table,
                        max_w: 0
                    };

                if (resize_tables[table._id].max_w < w)
                    resize_tables[table._id].max_w = w;

            }).on("click", (d) => {
                this.callCallbak(this, 'header.click', d);

                d3.event.stopPropagation();
            }).on("dblclick", (d) => {
                d3.event.stopPropagation();
            });
    }
    drawBase (g) {
        g.append('rect')
            .attr('class', 'base')
            .attr('width', (d) => {
                return d.w;
            })
            .attr('height', (d) => {
                return this.baseHeight(d);
            })
            .attr('fill', '#f8f8f8');
    }
    removeG (svg, data) {
        let area = svg.select('#entities');

        svg.selectAll('g.table')
            .data(data, (d) => { return d._id; })
            .exit()
            .remove();
    }
    drawG (svg, data) {
        let area = svg.select('#entities');

        return svg.selectAll('g.table')
            .data(data, (d) => { return d._id; })
            .enter()
            .append('g')
            .attr('class', 'table')
            .attr('transform', (d)=>{ return 'translate('+d.x+','+d.y+')'; })
            .attr('x', (d) => { return d.x; })
            .attr('y', (d) => { return d.y; })
            .call(d3.drag()
                  .on("start", (d,i,arr)=>{
                      d.drag = {
                          start: {x: d.x, y:d.y}
                      };
                  })
                  .on("drag",  (d,i,arr)=>{
                      d.x = Math.floor(d.x + d3.event.dx);
                      d.y = Math.floor(d.y + d3.event.dy);
                      this.move([d]);
                  })
                  .on("end",   (d,i,arr)=>{
                      this.callCallbak(this, 'move.end', d);

                      delete d.drag;
                  }));
    }
    move(tables) {
        let svg = this._d3svg._svg;

        svg.selectAll('g.table')
            .data(tables, (d)=>{ return d._id; })
            .attr('transform', (d)=>{
                return 'translate('+d.x+','+d.y+')';
            });

        this._Edge.moveEdges(svg, tables[0]._edges);
    }
    resize () {
        for (var k in this.resize_tables) {
            let data = this.resize_tables[k];
            let table = data.table;
            if (table.w == data.max_w)
                continue;

            table.w = data.max_w;

            this.callCallbak(this, 'resize', table);
        }
    }
    draw (data) {
        this.resize_tables = {};

        let svg = this._d3svg._svg;

        this.removeG(svg, data);
        let g = this.drawG(svg, data);

        this.drawBase(g);

        this._TableColumn.draw(g, this, {
            click: (d) => {
                this.callCallbak(this, 'columns.click', d);
                d3.event.stopPropagation();
            },
            dblclick: (d) => {
                d3.event.stopPropagation();
            }
        });

        this.drawHeader(g);

        this._Port.draw(g);

        this.resize();
    }
    reDraw (data) {
        let svg = this._d3svg._svg;
    }
    /* **************************************************************** *
     *  Drag & Drop
     * **************************************************************** */
}
