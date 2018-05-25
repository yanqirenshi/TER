<app>
    <page01 code="GRAPH" class="page {hide('GRAPH')}"></page01>
    <page02 code="TER"   class="page {hide('TER')}"></page02>
    <page03 code="ER"    class="page {hide('ER')}"></page03>

    <menu data={STORE.state().get('pages')}></menu>

    <style>
     app > .page {
         width: 100vw;
         height: 100vh;
         overflow: hidden;
         display: block;
     }
     app > .page.hide { display: none; }
     app > menu { position:fixed; right:11px; bottom:11px; }
    </style>

    <script>
     STORE.subscribe((action)=>{
         if (action.type=='MOVE-PAGE')
             this.update();
     });
     window.addEventListener('resize', (event) => {
         this.update();
     });

     this.on('mount', function () {
         Metronome.start();
     });

     this.hide = (code) => {
         let pages = STORE.state().get('pages');
         let page = pages[code];

         return page.active ? '' : 'hide';
     };
    </script>
</app>
