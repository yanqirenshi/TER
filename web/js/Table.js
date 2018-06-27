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
        let area = svg.select('#lines');
        svg.selectAll('line')
            .data(edges)
            .enter()
            .append('line')
            .attr('x1', (d) => { return d._port_from._column_instance._table.x + d._port_from.x + 4; })
            .attr('y1', (d) => { return d._port_from._column_instance._table.y + d._port_from.y + 4; })
            .attr('x2', (d) => { return d._port_to._column_instance._table.x   + d._port_to.x   + 4; })
            .attr('y2', (d) => { return d._port_to._column_instance._table.y   + d._port_to.y   + 4; })
            .attr('stroke', '#000')
            .attr('stroke-width', 1);
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
                d.x = column_instance.x + column_instance._table.w;
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
                      let _id = state.active;
                      let schema = state.list.find((d) => { return d._id = _id; });

                      ACTIONS.savePosition(schema, d);
                      delete d.drag;
                  }));
    }
    move(data) {
        let svg = this._d3svg._svg;

        let selection = svg.selectAll('g.table')
            .data(data, (d)=>{ return d._id; })
            .attr('transform', (d)=>{
                return 'translate('+d.x+','+d.y+')';
            });

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
