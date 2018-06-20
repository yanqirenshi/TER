<page03-sec_root>
    <svg></svg>

    <script>
     this.d3svg = null;
     this.ter = new Ter();

     this.draw = () => {
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
             clickSvg: () => {}
         };

         this.d3svg = this.ter.makeD3svg('page03-sec_root > svg', camera, callbacks);

         this.ter.drawTables(
             this.d3svg,
             STORE.state().get('er')
         );
     }

     STORE.subscribe((action) => {
         if (action.type=='FETCHED-ER' && action.mode=='FIRST')
             this.draw();
     });
    </script>
</page03-sec_root>
