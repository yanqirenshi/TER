class Table {
    constructor(reducer) {
    }
    drawHeader (g) {}
    drawColumns (g) {}
    drawBase (g) {
        g.append('rect')
            .attr('class', 'base')
            .attr('x', function (d) { return d.x; })
            .attr('y', function (d) { return d.y; })
            .attr('width', 80)
            .attr('height', 80)
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
