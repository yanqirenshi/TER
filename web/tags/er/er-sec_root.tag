<er-sec_root>
    <svg></svg>

    <operators data={operators()}
               callbak={clickOperator}></operators>

    <inspector callback={inspectorCallback}></inspector>

    <er-modal-logical-name data={modalData()}
                           callback={modalCallback}></er-modal-logical-name>

    <er-modal-description data={modal_target_table}
                          callback={modalCallback}></er-modal-description>

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

     this.modal_target_table = null;

     this.modalData = () => {
         let pages = STORE.state().get('site').pages;
         return pages.find((d) => { return d.code == 'er'; })
                     .modal
                     .logical_name;
     };

     this.state = () => {
         return STORE.state().get('er');
     };

     this.operators = () => {
         let state = STORE.state().get('site').pages.find((d) => { return d.code=='er'; });
         return state.operators;
     };
     this.clickOperator = (code) => {
         if (code=='move-center')
             return;

         if (code=='save-graph')
             ACTIONS.snapshotAll();
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
     this.modalCallback = (type, data) => {
         if (type=='click-close-button') {
             STORE.dispatch(ACTIONS.setDataToModalLogicalName('er', null));
             this.tags['er-modal-logical-name'].update();
             return;
         }
         if (type=='click-save-button') {
             data.schema_code = STORE.state().get('schemas').active;
             return ACTIONS.saveColumnInstanceLogicalName(data, 'er');
         }

         if (type=='close-modal-description') {
             this.modal_target_table = null;

             this.update();
             return;
         }

         if (type=='save-column-instance-description') {
             let schema_code = STORE.state().get('schemas').active;

             ACTIONS.saveColumnInstanceDescription(schema_code,
                                                   data.column_instance,
                                                   data.value,
                                                   'er');
             return;
         }

         if (type=='save-table-description') {
             let schema_code = STORE.state().get('schemas').active;

             ACTIONS.saveTableDescription(schema_code,
                                          data.table,
                                          data.value,
                                          'er');
             return;
         }
     };

     this.makeSketcher = () => {
         let camera = this.state().cameras[0];

         return new Sketcher({
             selector: 'er-sec_root > svg',
             x: camera.look_at.X,
             y: camera.look_at.Y,
             w: window.innerWidth,
             h: window.innerHeight,
             scale: camera.magnification,
             callbacks: {
                 svg: {
                     click: () => {
                         STORE.dispatch(ACTIONS.closeAllSubPanels());
                     },
                     move: {
                         end: (position) => {
                             let camera = this.state().cameras[0];
                             let state = STORE.get('schemas');
                             let schema = state.list.find((d) => {
                                 return d.code==state.active;
                             });

                             ACTIONS.saveErCameraLookAt(schema, camera, point);
                         },
                     },
                     zoom: (scale) => {
                         let camera = this.state().cameras[0];
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

     this.getActiveSchema = () => {
         let state = STORE.state().get('schemas');
         let code = state.active;

         return state.list.find((d) => { return d.code == code; });
     };

     STORE.subscribe(this, (action) => {
         if (action.mode=='FIRST') {
             if (action.type=='FETCHED-GRAPH')
                 ACTIONS.fetchErNodes(this.getActiveSchema(), action.mode);

             if (action.type=='FETCHED-ER-NODES')
                 ACTIONS.fetchErEdges(this.getActiveSchema(), action.mode);

             if (action.type=='FETCHED-ER-EDGES') {
                 if (!this.sketcher) {
                     this.sketcher = this.makeSketcher();
                     this.sketcher.makeCampus();
                 } else {
                     this.painter.clear(this.sketcher._d3svg);
                 }

                 let d3svg = this.sketcher._d3svg;

                 this.painter.drawTables(d3svg, STORE.state().get('er'));
             }
         }

         if (action.type=='CHANGE-SCHEMA') {
             ACTIONS.saveConfigAtDefaultSchema(action.data.schemas.active);
             return;
         }

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

     this.on('mount', () => {
         ACTIONS.fetchGraph('FIRST');
     });
    </script>
</er-sec_root>
