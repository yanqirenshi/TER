<page-ter_tab-graph>

    <div>
        <svg></svg>
    </div>

    <page-ter-controller parent_size={getSize()}></page-ter-controller>

    <page-ter-inspectors if={false} parent_size={getSize()}></page-ter-inspectors>

    <!-- TODO: 以下廃棄予定 -->
    <operators data={operators()}
               callbak={clickOperator}></operators>

    <script>
     this.getSize = () => {
         return {
             w: this.root.clientWidth,
             h: this.root.clientHeight,
         }
     };
    </script>

    <script>
     this.on('update', ()=>{
         if (!this.sketcher) {
             this.sketcher = this.makeSketcher();
             // TODO: Clear していた？
             // this.sketcher.makeCampus();
         }

         this.draw();
     });
     this.callbacks = {
         entity: {
             click: (d) => {
                 STORE.dispatch(ACTIONS.setDataToInspector(d));
                 d3.event.stopPropagation();
             },
         },
         svg: {
             click: () => {
                 STORE.dispatch(ACTIONS.setDataToInspector(null));
             },
             move: {
                 end: (position) => {
                     ACTIONS.saveTerCameraLookAt(this.getActiveCampus(), this.getCamera(), position);
                 },
             },
             zoom: (scale) => {
                 ACTIONS.saveTerCameraLookMagnification(this.getActiveCampus(), this.getCamera(), scale);
             }
         },
     };
    </script>

    <script>
     this.sketcher = null;
     this.painter = new Ter();
     this.getActiveCampus = () => {
         let active_campus = STORE.get('active.ter.campus');
         let campuses = STORE.get('ter.campuses');

         return campuses.ht[active_campus._id];
     };
     this.getCamera = () => {
         let campus = this.getActiveCampus();

         let camera = campus.cameras[0];
         if (!camera)
             return null;

         return campus.cameras[0].camera;
     };
     this.makeOption = () => {
         let camera = this.getCamera();
         let size   = this.getSize();

         if (!camera) {
             console.warn('Camera is Empty.');
             return;
         }

         return {
             element: {
                 selector: 'page-ter_tab-graph svg',
             },
             w: size.w,
             h: size.h,
             x: camera.look_at.x,
             y: camera.look_at.y,
             scale: camera.magnification,
             callbacks: this.callbacks.svg,
         };
     }
     this.makeSketcher = () => {
         return new DefaultSketcher(this.makeOption());
     };
     this.draw = () => {
         let forground  = this.sketcher.getBase('forground');
         let background = this.sketcher.getBase('background');

         this.painter
             .data(STORE.get('ter'))
             .sizing()
             .positioning()
             .draw(forground, background, {
                 entity: this.callbacks.entity
             });
     }
    </script>

    <style>
     page-ter_tab-graph {
         display: block;
         width: 100%;
         height: 100%;

         position: relative;
     }
     page-ter_tab-graph > div {
         display: flex;
         flex-direction: column;

         width:100%;
         height:100%;
     }
    </style>

    <script>
     ///
     /// TODO: 以下廃棄予定
     ///
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

</page-ter_tab-graph>
