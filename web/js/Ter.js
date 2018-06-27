class Ter {
    constructor (reducer) {
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
    makeD3svg (selector, camera, callbacks) {
        let _camera = Object.assign({}, camera);
        let d3svg = new D3Svg({
            d3: d3,
            svg: d3.select(selector),
            x: _camera.look_at.x || 0,
            y: _camera.look_at.y || 0,
            w: window.innerHeight,
            h: window.innerWidth,
            scale: _camera.magnification || 1,
            callbacks: callbacks
        });

        let areas = [
            {_id: -2,  name: 'lines'},
            {_id: -1,  name: 'entities'}
        ];
        let svg = d3svg.Svg();
        svg.selectAll('g')
            .data(areas)
            .enter()
            .append('g')
            .attr('id', (d) => {
                return '#' + d.name;
            });

        return d3svg;
    }
    // ER
    drawTables (d3svg, state) {
        let table = new Table({ d3svg:d3svg });
        let tables = state.tables.list;

        table.draw(tables);
    }
}
