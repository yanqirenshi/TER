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
             this.sketcher.makeCampus();
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
    </script>

    <script>
     this.sketcher = null;

     this.painter = new Er({
         callbacks: {
             table: {
                 move: {
                     end: (d) => {
                         let state = STORE.state().get('schemas');
                         let code = state.active;
                         let schema = state.list.find((d) => { return d.code == code; });

                         ACTIONS.savePosition(schema, d);
                     }
                 },
                 resize: (table) => {
                     let state = STORE.state().get('schemas');
                     let code = state.active;
                     let schema = state.list.find((d) => { return d.code == code; });

                     ACTIONS.saveTableSize(schema, table);
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
             }
         }
     });
     this.getSize = () => {
         return {
             w: this.root.clientWidth,
             h: this.root.clientHeight,
         }
     };
     this.getCamera = () => {
         let active_schema = STORE.get('active.er.schema');
         let schemas = STORE.get('er.schemas');

         let schema = schemas.ht[active_schema._id];

         let camera = schema.cameras[0];
         if (!camera)
             return null;

         return schema.cameras[0].camera;
     };
     this.makeSketcher = () => {
         let camera = this.getCamera();

         if (!camera) {
             console.warn('Camera is Empty.');
             return;
         }

         let size = this.getSize();

         return new Sketcher({
             selector: 'page-er_tab-graph svg',
             x: camera.look_at.x,
             y: camera.look_at.y,
             w: size.w,
             h: size.h,
             scale: camera.magnification,
             callbacks: {
                 svg: {
                     click: () => {
                         STORE.dispatch(ACTIONS.closeAllSubPanels());
                     },
                     move: {
                         end: (position) => {
                             let camera = this.state().cameras.list[0];
                             let state = STORE.get('schemas');
                             let schema = state.list.find((d) => {
                                 return d.code==state.active;
                             });

                             ACTIONS.saveErCameraLookAt(schema, camera, point);
                         },
                     },
                     zoom: (scale) => {
                         let camera = this.state().cameras.list[0];
                         let state = STORE.get('schemas');
                         let schema = state.list.find((d) => {
                             return d.code==state.active;
                         });

                         ACTIONS.saveErCameraLookMagnification(schema, camera, scale);
                     }
                 }
             }
         });
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
             let erapp = new ErApp();
             let file_name = STORE.get('schemas.active') + '.er';

             erapp.downloadJson(file_name, erapp.stateER2Json(STORE.state().get('er')));
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
