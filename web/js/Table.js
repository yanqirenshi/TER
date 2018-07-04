class Table {
    constructor(param) {
        this._d3svg = param.d3svg;
        this._padding = 11;
    }
    ///// ////////////////////////////////////////
    /////  Sizing
    ///// ////////////////////////////////////////
    /// header
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
    /// columns
    columnsWidth (d) {
        let padding = this._padding;
        return d.w - padding * 2;
    }
    columnHeight () { return 22; }
    columnsContentsHeight (d) {
        let column_height = this.columnHeight();
        let column_len = d._column_instances.length;
        let contents_h = column_height * ((column_len == 0) ? 1 : column_len);
        let padding = this._padding;
        return contents_h;
    }
    columnsHeight (d) {
        let padding_top = 3;
        let padding_bottm = this._padding;
        return this.columnsContentsHeight(d) + padding_top + padding_bottm;
    }
    /// base
    baseHeight (d) {
        return this.headerHight(d) + this.columnsHeight(d);
    }
    ///// ////////////////////////////////////////
    /////  Draw
    ///// ////////////////////////////////////////
    drawEdges (svg) {
        let edges = STORE.state().get('er').edges.list;
        let area = svg.selectAll('#lines');

        let val = (port, name) => {
            try {
                return port._column_instance._table[name] + port[name];
            } catch (e) {
                return 0;
            }
        };

        svg.selectAll('line')
            .data(edges, (d) => { return d._id; })
            .exit()
            .remove();

        svg.selectAll('line')
            .data(edges, (d) => { return d._id; })
            .enter()
            .append('line')
            .attr('x1', (d) => { return val(d._port_from, 'x'); })
            .attr('y1', (d) => { return val(d._port_from, 'y'); })
            .attr('x2', (d) => { return val(d._port_to,   'x'); })
            .attr('y2', (d) => { return val(d._port_to,   'y'); })
            .attr('id', (d) => {return d._id;})
            .attr('stroke', (d) => {
                return d.hide ? 'none' : '#000';
            })
            .attr('stroke-width', 1);
    }
    removeEdgeAll (svg) {
        svg.selectAll('line')
            .data([], (d) => { return d._id; })
            .exit()
            .remove();
    }
    removeAll () {
        let svg = this._d3svg._svg;
        this.removeEdgeAll(svg);
        this.removeGAll(svg);
    }
    drawPorts (g) {
        g.selectAll('circle')
            .data((d) => {
                return d._ports ? d._ports : [];
            })
            .enter()
            .append('circle')
            .attr('cx', (d) => {
                let column_instance = d._column_instance;
                if (d._class=='PORT-ER-OUT')
                    d.x = column_instance.x + column_instance._table.w;
                else
                    d.x = column_instance.x * -1;
                return d.x;
            })
            .attr('cy', (d) => {
                let column_instance = d._column_instance;
                d.y = column_instance.y + (column_instance.h/2) - 16;
                return d.y;
            })
            .attr('r', 4)
            .attr('fill', '#fff')
            .attr('stroke', '#000')
            .attr('stroke-width', 0.5);
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

        g.append('text')
            .attr('class', 'header')
            .attr('x', function (d) { return padding + 6; })
            .attr('y', function (d) { return padding + 16; })
            .attr('font-size', 16 + 'px')
            .text((d) => { return d.name; });
    }
    sortColumns (data) {
        let ids = [];
        let attributes = [];
        let timestamps = [];
        let others = [];
        for (var i in data) {
            if (data[i].column_type=='ID')
                ids.push(data[i]);
            else if (data[i].column_type=='ATTRIBUTE')
                attributes.push(data[i]);
            else if (data[i].column_type=='TIMESTAMP')
                timestamps.push(data[i]);
            else
                others.push(data[i]);
        }
        let sorter = (a,b)=>{ return a._id - b._id; };
        ids = ids.sort(sorter);
        attributes = attributes.sort(sorter);
        timestamps = timestamps.sort(sorter);
        others = others.sort(sorter);

        return [].concat(ids, attributes, timestamps, others);
    }
    drawColumns (g) {
        let padding = this._padding;

        g.append('rect')
            .attr('class', 'columns')
            .attr('x', (d) => { return padding; })
            .attr('y', (d) => { return this.headerHight(d); })
            .attr('width',  (d) => {
                return this.columnsWidth(d);
            })
            .attr('height', (d) => {
                return this.columnsContentsHeight(d);
            })
            .attr('fill', '#fefefe');

        g.selectAll('text.column')
            .data((d) => {
                return this.sortColumns(d._column_instances);
            })
            .enter()
            .append('text')
            .attr('class', 'column')
            .attr('x', (d) => {
                d.x = padding + 6;
                return d.x;
            })
            .attr('y', (d, i) => {
                d.y = this.headerHight(d.table) + (i+1) * 22;
                return d.y;
            })
            .attr('font-size', 16 + 'px')
            .attr('height', (d) => {
                d.h = this.columnHeight();
                return d.h;
            })
            .text((d) => { return d.name; });
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
    drawG (svg, data) {
        let area = svg.select('#entities');

        svg.selectAll('g.table')
            .data(data, (d) => { return d._id; })
            .exit()
            .remove();

        return svg.selectAll('g.table')
            .data(data)
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
                      let state = STORE.state().get('schemas');
                      let code = state.active;
                      let schema = state.list.find((d) => { return d.code == code; });

                      ACTIONS.savePosition(schema, d);
                      delete d.drag;
                  }));
    }
    removeGAll (svg) {
        svg.selectAll('g.table')
            .data([], (d) => { return d._id; })
            .exit()
            .remove();
    }
    move(tables) {
        let svg = this._d3svg._svg;

        svg.selectAll('g.table')
            .data(tables, (d)=>{ return d._id; })
            .attr('transform', (d)=>{
                return 'translate('+d.x+','+d.y+')';
            });

        let val = (port, name) => {
            try {
                return port._column_instance._table[name] + port[name];
            } catch (e) {
                return 0;
            }
        };

        let edges = tables[0]._edges;
        svg.selectAll('line')
            .data(edges, (d) => { return d._id; })
            .attr('x1', (d) => { return val(d._port_from, 'x'); })
            .attr('y1', (d) => { return val(d._port_from, 'y'); })
            .attr('x2', (d) => { return val(d._port_to,   'x'); })
            .attr('y2', (d) => { return val(d._port_to,   'y'); });
    }
    draw (data) {
        let svg = this._d3svg._svg;
        let g = this.drawG(svg, data);

        this.drawBase(g);
        this.drawColumns(g);
        this.drawHeader(g);
        this.drawPorts(g);

        this.drawEdges(svg);

        let base = g.selectAll('rect.base');
    }
}
