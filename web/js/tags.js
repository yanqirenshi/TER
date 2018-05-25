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

riot.tag2('menu', '<div class="menu-item {active(\'ER\')}" code="ER" onclick="{click}">ER</div> <div class="menu-item {active(\'TER\')}" code="TER" onclick="{click}">TER</div> <div class="menu-item {active(\'GRAPH\')}" code="GRAPH" onclick="{click}">Graph</div>', 'menu > .menu-item { float: right; margin-left: 11px; border-radius: 55px; width: 55px; height: 55px; background: #eeeeee; z-index: 99999999; opacity: 0.9; text-align: center; padding-top: 15px; box-shadow: 0 0 8px gray; } menu > .menu-item.active { background: rgba(236, 109, 113, 0.8); }', '', function(opts) {
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

riot.tag2('page01', '<svg></svg>', '', '', function(opts) {
     this.d3svg = null;
     this.graph = new Graph();

     STORE.subscribe((action) => {

     });

     this.on('mount', () => {
         this.d3svg = this.graph.makeD3svg('page01 > svg');
     });
});

riot.tag2('page02', '<svg></svg>', '', '', function(opts) {
     this.d3svg = null;
     this.graph = new Graph();

     STORE.subscribe((action) => {

     });

     this.on('mount', () => {
         this.d3svg = this.graph.makeD3svg('page02 > svg');
     });
});

riot.tag2('page03', '<svg></svg>', '', '', function(opts) {
     this.d3svg = null;
     this.graph = new Graph();

     STORE.subscribe((action) => {
         if(action.type=='FETCHED-ER')
             this.graph.drawTables(
                 this.d3svg,
                 STORE.state().get('er')
             );
     });

     this.on('mount', () => {
         this.d3svg = this.graph.makeD3svg('page03 > svg');
     });
});
