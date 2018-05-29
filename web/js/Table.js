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
    columnsContentsHeight (d) {
        let column_len = d.columns.length;
        let contents_h = column_len==0 ? 22 : column_len * 22;
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
        ids = ids.sort((a,b)=>{ return a._id - b._id; });
        attributes = attributes.sort((a,b)=>{ return a._id - b._id; });
        timestamps = timestamps.sort((a,b)=>{ return a._id - b._id; });
        others = others.sort((a,b)=>{ return a._id - b._id; });

        return [].concat(ids, attributes, timestamps, others);
    }
    drawColumns (g) {
        let padding = this._padding;

        g.append('rect')
            .attr('class', 'columns')
            .attr('x', (d) => { return padding; })
            .attr('y', (d) => { return this.headerHight(d); })
            .attr('width',  (d) => { return this.columnsWidth(d); })
            .attr('height', (d) => { return this.columnsContentsHeight(d); })
            .attr('fill', '#fefefe');

        g.selectAll('text.column')
            .data((d) => {
                return this.sortColumns(d.columns);
            })
            .enter()
            .append('text')
            .attr('class', 'column')
            .attr('x', (d) => {
                return padding + 6;
            })
            .attr('y', (d, i) => {
                return this.headerHight(d.table) + (i+1) * 22;
            })
            .attr('font-size', 16 + 'px')
            .text((d) => { return d.name; });
    }
    drawBase (g) {
        g.append('rect')
            .attr('class', 'base')
            .attr('width', (d) => { return d.w; })
            .attr('height', (d) => { return this.baseHeight(d); })
            .attr('fill', '#f8f8f8');
    }
    drawG (svg, data) {
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
                      ACTIONS.savePosition(d);
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

        let base = g.selectAll('rect.base');
    }
}
