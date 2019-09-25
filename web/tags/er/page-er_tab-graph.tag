<page-er_tab-graph>

    <div>
        <svg></svg>
    </div>

    <!-- TODO: 以下廃棄予定 -->
    <operators data={operators()}
               callbak={clickOperator}></operators>

    <inspector callback={inspectorCallback}></inspector>

    <script>
     this.on('update', () => {
         if (!this.sketcher) {
             this.sketcher = this.makeSketcher();
             // this.sketcher.makeCampus();
         } else {
             this.painter.clear(this.sketcher._d3svg);
         }

         let d3svg = this.sketcher._d3svg;

         this.painter.drawTables(d3svg, STORE.state().get('er'));
     });

     STORE.subscribe(this, (action) => {
         if (action.type=='SAVED-COLUMN-INSTANCE-LOGICAL-NAME' && action.from=='er') {
             this.update();
             this.painter.reDrawTable (action.redraw);
         }

         if (action.type=='SAVED-TABLE-DESCRIPTION' && action.from=='er') {
             this.modal_target_table = null;
             this.update();
         }

         if (action.type=='SAVED-COLUMN-INSTANCE-DESCRIPTION' && action.from=='er') {
             this.modal_target_table = null;
             this.update();
         }

     });
     this.callbacks = {
         table: {
             move: {
                 end: (d) => {
                     ACTIONS.savePosition(this.getActiveSchema(), d);
                 }
             },
             resize: (table) => {
                 ACTIONS.saveTableSize(this.getActiveSchema(), table);
             },
             header: {
                 click: (d) => {
                     STORE.dispatch(ACTIONS.setDataToInspector(d));
                 }
             },
             columns: {
                 click: (d) => {
                     STORE.dispatch(ACTIONS.setDataToInspector(d));
                 }
             },
         },
         svg: {
             click: () => {
                 STORE.dispatch(ACTIONS.closeAllSubPanels());
             },
             move: {
                 end: (position) => {
                     let camera = this.state().cameras.list[0];
                     let schema = this.getActiveSchema();
                     ACTIONS.saveErCameraLookAt(schema, camera, position);
                 },
             },
             zoom: (scale) => {
                 let camera = this.state().cameras.list[0];
                 let schema = this.getActiveSchema();
                 ACTIONS.saveErCameraLookMagnification(schema, camera, scale);
             }
         },
     };
    </script>

    <script>
     this.sketcher = null;
     this.painter = new Er({ callbacks: this.callbacks });

     this.getActiveSchema = () => {
         let active_schema = STORE.get('active.er.schema');
         let schemas = STORE.get('er.schemas');

         return schemas.ht[active_schema._id];
     } ;
     this.getSize = () => {
         return {
             w: this.root.clientWidth,
             h: this.root.clientHeight,
         }
     };
     this.getCamera = () => {
         let schema = this.getActiveSchema();

         let camera = schema.cameras[0];
         if (!camera)
             return null;

         return schema.cameras[0].camera;
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
                 selector: 'page-er_tab-graph svg',
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
    </script>

    <style>
     page-er_tab-graph {
         display: block;
         width: 100%;
         height: 100%;

         position: relative;
     }
     page-er_tab-graph > div {
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
     this.modal_target_table = null;

     this.modalData = () => {
         let pages = STORE.state().get('site').pages;
         return pages.find((d) => { return d.code == 'er'; })
                     .modal
                     .logical_name;
     };
     this.state = () => {
         return STORE.get('er');
     };
     this.operators = () => {
         let state = STORE.state().get('site').pages.find((d) => { return d.code=='er'; });
         return state.operators;
     };
     this.clickOperator = (code, e) => {
         if (code=='move-center')
             return;

         if (code=='save-graph')
             ACTIONS.snapshotAll();

         if (code=='download') {
             let er = new Er();
             let file_name = STORE.get('schemas.active') + '.er';
             let state = STORE.state().get('er');

             er.downloadJson(file_name, er.stateER2Json(state));
         }
     };
     this.inspectorCallback = (type, data) => {
         let page_code = 'er';

         if (type=='click-edit-logical-name') {
             STORE.dispatch(ACTIONS.setDataToModalLogicalName(page_code, data));
             this.tags['er-modal-logical-name'].update();
             return;
         }

         if (type=='click-save-column-description')
             return ACTIONS.saveColumnInstanceDescription(data, page_code)

         if (type=='edit-table-description') {
             this.modal_target_table = data;

             this.update();
             return;
         }

         if (type=='edit-column-instance-description') {
             this.modal_target_table = data;

             this.update();
             return;
         }
     };
    </script>

</page-er_tab-graph>
