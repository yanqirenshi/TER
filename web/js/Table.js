class Table {
    constructor(reducer) {
        this._padding = 11;
    }
    headerWidth (d) {
        let padding = this._padding;
        return d.w - padding * 2;
    }
    headerHight (d) {
        return 22;
    }
    columnsWidth (d) {
        let padding = this._padding;
        return d.w - padding * 2;
    }
    columnsHeight (d) {
        let padding = this._padding;
        return d.h - padding * 2 - 22;
    }
    drawHeader (g) {
        let padding = this._padding;
        let self = this;
        g.append('rect')
            .attr('class', 'header')
            .attr('x', function (d) { return d.x + padding; })
            .attr('y', function (d) { return d.y + padding; })
            .attr('width',  (d) => { return this.headerWidth(d); })
            .attr('height', (d) => { return this.headerHight(d); })
            .attr('fill', '#f0f0f0');
    }
    drawColumns (g) {
        let padding = this._padding;
        g.append('rect')
            .attr('class', 'columns')
            .attr('x', function (d) { return d.x + padding; })
            .attr('y', function (d) { return d.y + padding + 22; })
            .attr('width',  (d) => { return this.columnsWidth(d); })
            .attr('height', (d) => { return this.columnsHeight(d); })
            .attr('fill', '#fefefe');
    }
    drawBase (g) {
        g.append('rect')
            .attr('class', 'base')
            .attr('x', function (d) { return d.x; })
            .attr('y', function (d) { return d.y; })
            .attr('width', function (d) { return d.w; })
            .attr('height', function (d) { return d.h; })
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
    }
}
