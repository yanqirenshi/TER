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

        return new D3Svg({
            d3: d3,
            svg: d3.select(selector),
            x: _camera.look_at.x || 0,
            y: _camera.look_at.y || 0,
            w: window.innerHeight,
            h: window.innerWidth,
            scale: _camera.magnification || 1,
            callbacks: callbacks
        });
    }
    // ER
    findColumnInstances (table, r_list, column_instances_ht) {
         let rs = r_list;
         let cis = column_instances_ht;
         let out = [];

         for (var i in rs) {
             let r = rs[i];
             if (r['from-id']==table._id && r['to-class']=='COLUMN-INSTANCE') {
                 let column = cis[r['to-id']];
                 column.table = table;
                 out.push(column);
             }
         }

         return out;
    }
    findColumnInstancesPorts (table, r_froms, ports_ht) {
        let out = [];
        for (var i in table.columns) {
            let column = table.columns[i];

            if (r_froms[column._id]) {
                for (var k in r_froms[column._id]){
                    let r = r_froms[column._id][k];
                    if (r['to-class']=='PORT-ER') {
                        let port = ports_ht[r['to-id']];
                        port.column_id = column.id;
                        out.push(port);
                    }
                }
            }
        }

        return out;
    }
    drawTables (d3svg, state) {
        let table = new Table({ d3svg:d3svg });
        let tables = state.tables.list;

        for (var i in tables) {
            let table = tables[i];

            table.columns = this.findColumnInstances(
                tables[i],
                state.relashonships.list,
                state.column_instances.ht);

            table.ports = this.findColumnInstancesPorts(
                table,
                state.relashonships.from,
                state.ports.ht);
        }

        table.draw(tables);
    }
}
