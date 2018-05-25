class Table {
    constructor(reducer) {
        this._padding = 11;
    }
    /// ////////////////////////////////////////
    /// Sizing
    /// ////////////////////////////////////////
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
    baseHeight (d) {
        return this.headerHight(d) + this.columnsHeight(d);
    }
    /// ////////////////////////////////////////
    /// Draw
    /// ////////////////////////////////////////
    drawHeader (g) {
        let padding = this._padding;
        let self = this;
        g.append('rect')
            .attr('class', 'header')
            .attr('x', function (d) { return d.x + padding; })
            .attr('y', function (d) { return d.y + padding; })
            .attr('width',  (d) => { return this.headerWidth(d); })
            .attr('height', (d) => { return this.headerContentsHight(d); })
            .attr('fill', '#fefefe');

        g.append('text')
            .attr('class', 'header')
            .attr('x', function (d) { return d.x + padding + 6; })
            .attr('y', function (d) { return d.y + padding + 16; })
            .attr('font-size', 16 + 'px')
            .text((d) => { return d.name; });
    }
    drawColumns (g) {
        let padding = this._padding;
        g.append('rect')
            .attr('class', 'column')
            .attr('x', (d) => { return d.x + padding; })
            .attr('y', (d) => { return d.y + this.headerHight(d); })
            .attr('width',  (d) => { return this.columnsWidth(d); })
            .attr('height', (d) => { return this.columnsContentsHeight(d); })
            .attr('fill', '#fefefe');

        g.selectAll('text.column')
            .data((d) => { return d.columns; })
            .enter()
            .append('text')
            .attr('class', 'column')
            .attr('x', (d) => {
                return d.table.x + padding + 6;
            })
            .attr('y', (d, i) => {
                return d.table.y + this.headerHight(d.table) + (i+1) * 22;
            })
            .attr('font-size', 16 + 'px')
            .text((d) => { return d.name; });
    }
    drawBase (g) {
        g.append('rect')
            .attr('class', 'base')
            .attr('x', (d) => { return d.x; })
            .attr('y', (d) => { return d.y; })
            .attr('width', (d) => { return d.w; })
            .attr('height', (d) => { return this.baseHeight(d); })
            .attr('fill', '#f8f8f8');

    }
    drawG (svg, data) {
        return svg.selectAll('g.table')
            .data(data)
            .enter()
            .append('g')
            .attr('class', 'table');
    }
    draw (d3svg, data) {
        let svg = d3svg._svg;
        let g = this.drawG(svg, data);

        this.drawBase(g);
        this.drawColumns(g);
        this.drawHeader(g);

        let base = g.selectAll('rect.base');
        base.call(d3.drag()
               .on("drag", function (d, i) {
                   d.x += d3.event.dx;
                   d.y += d3.event.dy;
                   dump(d);
               })
               .on('start', function () {
               })
               .on('end', function (d, i) {
               }));
    }
}
