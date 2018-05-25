<page03 ref="self">

    <svg></svg>

    <script>
     this.d3svg = null;

     this.random = (type) => {
         let min;
         let max;

         if (type=='x') {
             min = 11;
             max = this.refs.self.clientWidth - 11;
         }
         if (type=='y') {
             min = 11;
             max = this.refs.self.clientHeight - 11;
         }
         return Math.floor( Math.random() * (max + 1 - min) ) + min ;
     }
     this.findColumnInstances = (table, r_list, column_instances_ht) => {
         let rs = r_list;
         let cis = column_instances_ht;
         let out = [];

         for (var i in rs) {
             let r = rs[i];
             if (r['from-id']==table._id && r['to-class']=='COLUMN-INSTANCE') {
                 let column = cis[r['to-id']];
                 column.table = table
                 out.push(column);
             }
         }

         return out;
     }
     this.drawTables = () => {
         let table = new Table();
         let state = STORE.state().get('er');
         let tables = state.tables.list;

         for (var i in tables)
             tables[i].columns = this.findColumnInstances(tables[i],
                                                          state.relashonships.list,
                                                          state.column_instances.ht);

         table.draw(this.d3svg, tables);
     };

     STORE.subscribe((action) => {
         if(action.type=='FETCHED-ER')
             this.drawTables();
     });

     this.on('mount', () => {
         this.d3svg = new D3Svg({
             d3: d3,
             svg: d3.select("page03 > svg"),
             x: 0,
             y: 0,
             w: this.refs.self.clientWidth,
             h: this.refs.self.clientHeight,
             scale: 1
         });
     });
    </script>
</page03>
