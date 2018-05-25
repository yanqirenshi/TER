riot.tag2('app', '<page01 code="GRAPH" class="page {hide(\'GRAPH\')}"></page01> <page02 code="TER" class="page {hide(\'TER\')}"></page02> <page03 code="ER" class="page {hide(\'ER\')}"></page03> <menu data="{STORE.state().get(\'pages\')}"></menu>', 'app > .page { width: 100vw; height: 100vh; overflow: hidden; display: block; } app > .page.hide { display: none; } app > menu { position:fixed; right:11px; bottom:11px; }', '', function(opts) {
     STORE.subscribe((action)=>{
         if (action.type=='MOVE-PAGE')
             this.update();
     });
     window.addEventListener('resize', (event) => {
         this.update();
     });

     this.on('mount', function () {
         Metronome.start();
     });

     this.hide = (code) => {
         let pages = STORE.state().get('pages');
         let page = pages[code];

         return page.active ? '' : 'hide';
     };
});

riot.tag2('menu', '<div class="menu-item {active(\'ER\')}" code="ER" onclick="{click}">ER</div> <div class="menu-item {active(\'TER\')}" code="TER" onclick="{click}">TER</div> <div class="menu-item {active(\'GRAPH\')}" code="GRAPH" onclick="{click}">Graph</div>', 'menu > .menu-item { float: right; margin-left: 11px; border-radius: 55px; width: 55px; height: 55px; background: #eeeeee; z-index: 99999999; opacity: 0.9; text-align: center; padding-top: 15px } menu > .menu-item.active { background: rgba(236, 109, 113, 0.8); }', '', function(opts) {
     this.active = (code) => {
         let page = this.opts.data[code];

         return page.active ? 'active' : '';
     };
     this.click = (e) => {
         let target = e.target;
         let hash = '#' + target.getAttribute('CODE');

         if (hash!=location.hash)
             location.hash = hash;
     };
});

riot.tag2('page01', '<h1>Graph</h1>', '', '', function(opts) {
});

riot.tag2('page02', '<h1>TER</h1>', '', '', function(opts) {
});

riot.tag2('page03', '<svg></svg>', '', 'ref="self"', function(opts) {
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
});
