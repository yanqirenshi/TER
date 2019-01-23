<ter-sec_root>
    <svg id="ter-sec_root-svg" ref="svg"></svg>

    <inspector callback={inspectorCallback}></inspector>

    <script>
     this.inspectorCallback = (type, data) => {
     };
    </script>

    <script>
     this.d3svg = null;
     this.svg   = null;

     this.ter = new Ter();

     this.draw = () => {
         let forground  = this.svg.selectAll('g.base.forground');
         let background = this.svg.selectAll('g.base.background');
         let state      = STORE.get('ter');

         this.ter
             .data(state)
             .sizing()
             .positioning()
             .draw(forground, background, {
                 entity: {
                     click: (d) => {
                         STORE.dispatch(ACTIONS.setDataToInspector(d));
                         d3.event.stopPropagation();
                     }}});
     };
     this.makeBases = (d3svg) => {
         let svg = d3svg.Svg();

         let base = [
             { _id: -10, code: 'background' },
             { _id: -15, code: 'forground' },
         ];

         svg.selectAll('g.base')
            .data(base, (d) => { return d._id; })
            .enter()
            .append('g')
            .attr('class', (d) => {
                return 'base ' + d.code;
            });
     }
     this.makeD3Svg = () => {
         let w = window.innerWidth;
         let h = window.innerHeight;

         let svg_tag = this.refs['svg'];
         svg_tag.setAttribute('height',h);
         svg_tag.setAttribute('width',w);

         let camera = STORE.get('ter.camera');

         let d3svg = new D3Svg({
             d3: d3,
             svg: d3.select("#ter-sec_root-svg"),
             x: camera.look_at.X,
             y: camera.look_at.Y,
             w: w,
             h: h,
             scale: camera.magnification,
             callbacks: {
                 clickSvg: () => {
                     STORE.dispatch(ACTIONS.setDataToInspector(null));
                     d3.event.stopPropagation();
                 },
                 moveEndSvg: (position) => {
                     let state = STORE.get('schemas');
                     let schema = state.list.find((d) => { return d.code==state.active; });
                     let camera = STORE.get('ter.camera');

                     ACTIONS.saveTerCameraLookAt(schema, camera, position);
                 },
                 zoomSvg: (scale) => {
                     let state = STORE.get('schemas');
                     let schema = state.list.find((d) => { return d.code==state.active; });
                     let camera = STORE.get('ter.camera');

                     ACTIONS.saveTerCameraLookMagnification(schema, camera, scale);
                 }
             }
         });

         this.makeBases(d3svg);

         return d3svg;
     }
     STORE.subscribe((action) => {
         if(action.type=='SAVED-TER-PORT-POSITION') {
             let state = STORE.get('ter');

             let port_id = action.target._id;
             let edges = state.relationships.indexes.to[port_id];
             let edge = null;
             for (let key in edges) {
                 let edge_tmp = edges[key];
                 if (edge_tmp.from_class=="IDENTIFIER-INSTANCE")
                     edge = edge_tmp;
             }

             this.ter.movePort(edge._from._entity, action.target);
         }

         if (action.mode=='FIRST') {
             if (action.type=='FETCHED-TER-ENVIRONMENT')
                 ACTIONS.fetchTerEntities(action.mode);

             if (action.type=='FETCHED-TER-ENTITIES')
                 ACTIONS.fetchTerIdentifiers(action.mode);

             if (action.type=='FETCHED-TER-IDENTIFIERS')
                 ACTIONS.fetchTerAttributes(action.mode);

             if (action.type=='FETCHED-TER-ATTRIBUTES')
                 ACTIONS.fetchTerPorts(action.mode);

             if (action.type=='FETCHED-TER-PORTS')
                 ACTIONS.fetchTerEdges(action.mode);

             if(action.type=='FETCHED-ER-EDGES') {
                 this.d3svg = this.makeD3Svg();
                 this.svg = this.d3svg.Svg();

                 this.draw();
             }
         }
     });

     this.on('mount', () => {
         ACTIONS.fetchTerEnvironment('FIRST');
     });
    </script>
</ter-sec_root>
