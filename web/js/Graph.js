class Graph {
    constructor (reducer) {
    }
    // Common
    random (parent, type) {
        let min;
        let max;

        if (type=='x') {
            min = 11;
            max = parent.clientWidth - 11;
        }
        if (type=='y') {
            min = 11;
            max = parent.clientHeight - 11;
        }
        return Math.floor( Math.random() * (max + 1 - min) ) + min ;
    }
    makeD3svg (selector) {
        return new D3Svg({
            d3: d3,
            svg: d3.select(selector),
            x: 0,
            y: 0,
            w: window.innerHeight,
            h: window.innerWidth,
            scale: 1
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
    drawTables (d3svg, state) {
        let table = new Table();
        let tables = state.tables.list;

        for (var i in tables)
            tables[i].columns = this.findColumnInstances(
                tables[i],
                state.relashonships.list,
                state.column_instances.ht);

        table.draw(d3svg, tables);
    }
}
