<page03-sec_root>
    <svg></svg>

    <operators data={operators()}
               callbak={clickOperator}></operators>

    <script>
     this.d3svg = null;
     this.ter = new Ter();

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
         if (action.type=='FETCHED-ER') {
             let d3svg = this.getD3Svg();

             this.ter.clear(d3svg);
             this.ter.drawTables(d3svg, STORE.state().get('er'));
         }
     });
    </script>
</page03-sec_root>
