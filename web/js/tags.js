riot.tag2('app', '<page01 class="page"></page01> <page02 class="page"></page02> <page03 class="page"></page03>', 'app > .page { width: 100vw; height: 100vh; overflow: hidden; display: block; }', '', function(opts) {
     window.addEventListener('resize', (event) => {
         this.update();
     });

     this.on('mount', function () {
         Metronome.start();
     });
});

riot.tag2('page01', '<svg></svg>', '', 'ref="self"', function(opts) {
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
             svg: d3.select("page01 > svg"),
             x: 0,
             y: 0,
             w: this.refs.self.clientWidth,
             h: this.refs.self.clientHeight,
             scale: 1
         });
     });
});

riot.tag2('page02', '', '', '', function(opts) {
});

riot.tag2('page03', '', '', '', function(opts) {
});
