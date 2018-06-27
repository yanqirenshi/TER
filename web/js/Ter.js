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
        let look_at = (camera, name) => {
            if (camera && camera.look_at)
                return camera.look_at[name];
            else
                return 0;
        };
        let d3svg = new D3Svg({
            d3: d3,
            svg: d3.select(selector),
            x: look_at(_camera, 'x'),
            y: look_at(_camera, 'y'),
            w: window.innerHeight,
            h: window.innerWidth,
            scale: _camera.magnification || 1,
            callbacks: callbacks ? callbacks : {
                moveEndSvg: null,
                zoomSvg: null,
                clickSvg: null
            }
        });

        // let svg = d3svg.Svg();
        // svg.append('g').attr('id', '#lines');
        // svg.append('g').attr('id', '#entities');

        return d3svg;
    }
    // ER
    drawTables (d3svg, state) {
        let table = new Table({ d3svg:d3svg });
        let tables = state.tables.list;

        table.draw(tables);
    }
}
