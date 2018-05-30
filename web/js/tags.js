riot.tag2('app', '<page01 code="GRAPH" class="page {hide(\'GRAPH\')}"></page01> <page02 code="TER" class="page {hide(\'TER\')}"></page02> <page03 code="ER" class="page {hide(\'ER\')}"></page03> <menu data="{STORE.state().get(\'pages\')}"></menu>', 'app > .page { width: 100vw; height: 100vh; overflow: hidden; display: block; } app > .page.hide { display: none; } app > menu { position:fixed; right:11px; bottom:11px; }', '', function(opts) {
     STORE.subscribe((action)=>{
         if (action.type=='MOVE-PAGE')
             this.update();

         if (action.type=='FETCHED-SCHEMA' && action.mode=='FIRST')
             ACTIONS.fetchGraph('FIRST');

         if (action.type=='FETCHED-GRAPH' && action.mode=='FIRST')
             ACTIONS.fetchEr(action.mode);

         if (action.type=='FETCHED-ER' && action.mode=='FIRST')
             ACTIONS.fetchTer(action.mode);
     });
     window.addEventListener('resize', (event) => {
         this.update();
     });

     this.on('mount', function () {
         Metronome.start();
         ACTIONS.fetchSchema('FIRST');
     });

     this.hide = (code) => {
         let pages = STORE.state().get('pages');
         let page = pages[code];

         return page.active ? '' : 'hide';
     };
});

riot.tag2('menu', '<div class="menu-item {active(\'ER\')}" code="ER" onclick="{click}">ER</div> <div class="menu-item {active(\'TER\')}" code="TER" onclick="{click}">TER</div> <div class="menu-item {active(\'GRAPH\')}" code="GRAPH" onclick="{click}">Graph</div>', 'menu > .menu-item { float: right; margin-left: 11px; border-radius: 55px; width: 55px; height: 55px; background: rgba(255, 255, 255, 0.9); z-index: 99999999; text-align: center; padding-top: 12px; border: 3px solid rgb(238, 238, 238); box-shadow: 0 0 8px gray; } menu > .menu-item.active { background: rgba(236, 109, 113, 0.9); color: #ffffff; border: 3px solid rgba(236, 109, 113); }', '', function(opts) {
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
     this.ter = new Ter();

     this.drawNods = ()=>{
         let state = STORE.state().get('graph');
         let nodes = state.nodes;
         let svg = this.d3svg._svg;

         return svg.selectAll('circle')
                   .data(nodes.list)
                   .enter()
                   .append('circle')
                   .attr('class', (d)=>{
                       return 'node ' + d._class.toLowerCase();
                   })
                   .attr('cx', (d)=>{ return d.x })
                   .attr('cy', (d)=>{ return d.y })
                   .attr('r', '33')
                   .attr('fill', '#f88');
     };

     this.drawEdges = ()=>{
         let state = STORE.state().get('graph');
         let nodes = state.nodes.ht;
         let edges = state.edges.list;
         let svg = this.d3svg._svg;

         return svg.selectAll('line')
                   .data(edges)
                   .enter()
                   .append('line')
                   .attr('class', 'edges')
                   .attr('x1', (d)=>{ return nodes[d['from-id']].x })
                   .attr('y1', (d)=>{ return nodes[d['from-id']].y })
                   .attr('x2', (d)=>{ return nodes[d['to-id']].x })
                   .attr('y2', (d)=>{ return nodes[d['to-id']].y })
                   .attr('stroke', "#888888");
     };

     STORE.subscribe((action) => {
         if(action.type=='FETCHED-GRAPH') {
             let state = STORE.state().get('graph');
             let nodes = state.nodes;
             let w = window.innerWidth * 3;
             let h = window.innerHeight * 3;

             for (var i in nodes.list) {
                 nodes.list[i].x = this.ter.random(w, 'x');
                 nodes.list[i].y = this.ter.random(h, 'y');
             }

             this.drawEdges();
             this.drawNods();
         }
     });

     this.on('mount', () => {
         this.d3svg = this.ter.makeD3svg('page01 > svg');
     });
});

riot.tag2('page02', '<svg></svg>', '', '', function(opts) {
     this.d3svg = null;
     this.ter = new Ter();
     this.entity = new Entity();

     this.drawNodes = (d3svg, state)=>{
         let svg = d3svg._svg;
         let nodes = state.nodes.list;
     };
     this.drawEdges = (d3svg, state)=>{
         let svg = d3svg._svg;
         let nodes = state.nodes.ht;
         let edges = state.edges.list;
     };

     STORE.subscribe((action) => {
         if(action.type=='FETCHED-TER')
             this.entity.draw(this.d3svg, STORE.state().get('ter'))
     });

     this.on('mount', () => {
         this.d3svg = this.ter.makeD3svg('page02 > svg');

         new Grid().draw(this.d3svg);
     });

});

riot.tag2('page03', '<svg></svg>', '', '', function(opts) {
     this.d3svg = null;
     this.ter = new Ter();

     STORE.subscribe((action) => {
         if(action.type=='FETCHED-ER')
             this.ter.drawTables(
                 this.d3svg,
                 STORE.state().get('er')
             );
     });

     this.on('mount', () => {
         this.d3svg = this.ter.makeD3svg('page03 > svg');
     });
});
