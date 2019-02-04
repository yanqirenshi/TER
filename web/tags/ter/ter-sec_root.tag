<ter-sec_root>
    <svg id="ter-sec_root-svg" ref="svg"></svg>

    <inspector callback={inspectorCallback}></inspector>

    <script>
     this.inspectorCallback = (type, data) => {
     };
    </script>

    <script>
     this.sketcher = null;

     this.painter = new Ter();

     this.makeSketcher = () => {
         let camera = STORE.get('ter.camera');

         return new Sketcher({
             selector: 'ter-sec_root svg',
             x: camera.look_at.X,
             y: camera.look_at.Y,
             w: window.innerWidth,
             h: window.innerHeight,
             scale: camera.magnification,
             callbacks: {
                 svg: {
                     click: () => {
                         STORE.dispatch(ACTIONS.setDataToInspector(null));
                     },
                     move: {
                         end: (position) => {
                             let state = STORE.get('schemas');
                             let schema = state.list.find((d) => { return d.code==state.active; });
                             let camera = STORE.get('ter.camera');

                             ACTIONS.saveTerCameraLookAt(schema, camera, position);
                         },
                     },
                     zoom: (scale) => {
                         let state = STORE.get('schemas');
                         let schema = state.list.find((d) => { return d.code==state.active; });
                         let camera = STORE.get('ter.camera');

                         ACTIONS.saveTerCameraLookMagnification(schema, camera, scale);
                     }
                 }
             }
         });
     };
     this.draw = () => {
         let svg = this.sketcher.svg();

         let forground  = svg.selectAll('g.base.forground');
         let background = svg.selectAll('g.base.background');
         let state      = STORE.get('ter');

         this.painter
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
     STORE.subscribe(this, (action) => {
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

             this.painter.movePort(edge._from._entity, action.target);
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

             if(action.type=='FETCHED-TER-EDGES') {
                 this.sketcher = this.makeSketcher();
                 this.sketcher.makeCampus();

                 this.draw();
             }
         }
     });

     this.on('mount', () => {
         ACTIONS.fetchTerEnvironment('FIRST');
     });
    </script>
</ter-sec_root>
