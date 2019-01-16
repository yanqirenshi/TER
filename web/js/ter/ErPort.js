class Port {
    constructor() {}
    draw (g) {
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
}
