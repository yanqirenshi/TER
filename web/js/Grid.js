class Grid {
    constructor() {
    }
    drawG (d3svg, nodes) {
        let svg = d3svg._svg;
        return svg.selectAll('g.entity')
            .data(nodes)
            .enter()
            .append('g')
            .attr('class', 'entity');

    }
    draw (d3svg) {
        let svg = d3svg._svg;
        let width = 1920 * 10;
        let width_r = Math.floor(width/2);
        let height = 1080 * 10;
        let height_r = Math.floor(height/2);
        let data = [
            {
                from: {x:width_r * -1, y:0},
                to:   {x:width_r,      y:0}
            },
            {
                from: {x:0, y:height_r * -1},
                to:   {x:0, y:height_r}
            }
        ];


        return svg.selectAll('line')
            .data(data)
            .enter()
            .append('line')
            .attr('x1', (d)=>{ return d.from.x; })
            .attr('y1', (d)=>{ return d.from.y; })
            .attr('x2', (d)=>{ return d.to.x; })
            .attr('y2', (d)=>{ return d.to.y; })
            .attr('stroke', '#aaaaaa');
    }
}
