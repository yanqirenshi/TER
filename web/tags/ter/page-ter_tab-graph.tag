<page-ter_tab-graph>

    <page-ter-controller></page-ter-controller>

    <svg id="ter-sec_root-svg" ref="svg"></svg>

    <operators data={operators()}
               callbak={clickOperator}></operators>

    <inspector callback={inspectorCallback}></inspector>

    <script>
     this.inspectorCallback = (type, data) => {
     };
    </script>

    <script>
     this.operators = () => {
         let state = STORE.state().get('site').pages.find((d) => { return d.code=='ter'; });
         return state.operators;
     };

     this.clickOperator = (code, e) => {
         if (code=='download') {
             let erapp = new ErApp();
             let file_name = STORE.get('schemas.active') + '.ter';

             erapp.downloadJson(file_name, erapp.stateTER2Json(STORE.state().get('ter')));
         }
     };
    </script>

    <script>
     this.sketcher = null;

     this.painter = new Ter();

     this.getCamera = () => {
         let active_campus = STORE.get('active.ter.campus');
         let campuses = STORE.get('ter.campuses');

         let campus = campuses.ht[active_campus._id];

         let camera = campus.cameras[0];
         if (!camera)
             return null;

         return campus.cameras[0].camera;
     };
     this.makeSketcher = () => {
         let camera = this.getCamera();

         if (!camera) {
             console.warn('Camera is Empty.');
             return;
         }

         return new Sketcher({
             selector: 'page-ter_tab-graph svg',
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
             .draw(forground,
                   background,
                   {
                       entity: {
                           click: (d) => {
                               STORE.dispatch(ACTIONS.setDataToInspector(d));
                               d3.event.stopPropagation();
                           }}
                   });
     };
     this.on('update', ()=>{
         if (!this.sketcher) {
             this.sketcher = this.makeSketcher();
             this.sketcher.makeCampus();
         }

         this.draw();
     });
    </script>
</page-ter_tab-graph>
