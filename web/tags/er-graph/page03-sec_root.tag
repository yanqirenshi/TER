<page03-sec_root>
    <svg></svg>

    <script>
     this.d3svg = null;
     this.ter = new Ter();

     this.getD3Svg = () => {
         if (this.d3svg) return this.d3svg

         let camera = STORE.state().get('er').cameras[0];
         let callbacks = {
             moveEndSvg: (point) => {
                 let camera = STORE.state().get('er').cameras[0];
                 ACTIONS.saveCameraLookAt(camera, point);
             },
             zoomSvg: (scale) => {
                 let camera = STORE.state().get('er').cameras[0];
                 ACTIONS.saveCameraLookMagnification(camera, scale);
             },
             clickSvg: () => {
                 STORE.dispatch(ACTIONS.closeAllSubPanels());
             }
         };

         this.d3svg = this.ter.makeD3svg('page03-sec_root > svg', camera, callbacks);

         return this.d3svg
     }

     STORE.subscribe((action) => {
         if (action.type=='FETCHED-ER') {
             let d3svg = this.getD3Svg();

             this.ter.clear(d3svg);
             this.ter.drawTables(d3svg, STORE.state().get('er'));
         }
     });
    </script>
</page03-sec_root>
