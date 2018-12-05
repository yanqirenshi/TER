<page03-sec_root>
    <svg></svg>

    <operators data={operators()}
               callbak={clickOperator}></operators>

    <inspector callback={inspectorCallback}></inspector>

    <page03-modal-logical-name data={modalData()}
                               callback={modalCallback}></page03-modal-logical-name>

    <page03-modal-description data={modal_target_table}
                              callback={modalCallback}></page03-modal-description>

    <script>
     this.d3svg = null;
     this.ter = new Ter();
     this.modal_target_table = null;

     this.modalData = () => {
         let pages = STORE.state().get('site').pages;
         return pages.find((d) => { return d.code == 'page03'; })
                     .modal
                     .logical_name;
     };

     this.state = () => {
         return STORE.state().get('er');
     };

     this.operators = () => {
         let state = STORE.state().get('site').pages.find((d) => { return d.code=='page03'; });
         return state.operators;
     };
     this.clickOperator = (code) => {
         if (code=='move-center')
             return;

         if (code=='save-graph')
             ACTIONS.snapshotAll();
     };
     this.inspectorCallback = (type, data) => {
         let page_code = 'page03';

         if (type=='click-edit-logical-name') {
             STORE.dispatch(ACTIONS.setDataToModalLogicalName(page_code, data));
             this.tags['page03-modal-logical-name'].update();
             return;
         }

         if (type=='click-save-column-description')
             return ACTIONS.saveColumnInstanceDescription(data, page_code)

         if (type=='edit-table-description') {
             this.modal_target_table = data;

             this.update();
             return;
         }
     };
     this.modalCallback = (type, data) => {
         if (type=='click-close-button') {
             STORE.dispatch(ACTIONS.setDataToModalLogicalName('page03', null));
             this.tags['page03-modal-logical-name'].update();
             return;
         }
         if (type=='click-save-button') {
             data.schema_code = STORE.state().get('schemas').active;
             return ACTIONS.saveColumnInstanceLogicalName(data, 'page03');
         }

         if (type=='close-modal-table-description') {
             this.modal_target_table = null;

             this.update();
             return;
         }
         if (type=='save-table-description') {
             let schema_code = STORE.state().get('schemas').active;

             ACTIONS.saveTableDescription(schema_code, data.table, data.value, 'page03');
             return;
         }
     };
     this.getD3Svg = () => {
         if (this.d3svg) return this.d3svg

         let camera = this.state().cameras[0];

         let callbacks = {
             moveEndSvg: (point) => {
                 let camera = this.state().cameras[0];
                 ACTIONS.saveCameraLookAt(camera, point);
             },
             zoomSvg: (scale) => {
                 let camera = this.state().cameras[0];
                 ACTIONS.saveCameraLookMagnification(camera, scale);
             },
             clickSvg: () => {
                 STORE.dispatch(ACTIONS.closeAllSubPanels());
             }
         };

         this.d3svg = this.ter.makeD3svg('page03-sec_root > svg', camera, callbacks);

         return this.d3svg
     };

     STORE.subscribe((action) => {
         if (action.type=='FETCHED-ER-EDGES') {
             let d3svg = this.getD3Svg();

             this.ter.clear(d3svg);
             this.ter.drawTables(d3svg, STORE.state().get('er'));
         }

         if (action.type=='SAVED-COLUMN-INSTANCE-LOGICAL-NAME' && action.from=='page03') {
             this.update();
             this.ter.reDrawTable (action.redraw);
         }

         if (action.type=='SAVED-TABLE-DESCRIPTION' && action.from=='page03') {
             this.modal_target_table = null;
             this.update();
         }
     });
    </script>
</page03-sec_root>
