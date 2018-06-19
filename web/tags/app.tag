<app>
    <menu-bar brand={{label:'TER'}} site={site()} moves={[]}></menu-bar>

    <schema></schema>

    <div ref="page-area"></div>

    <style>
     app > .page {
         width: 100vw;
         height: 100vh;
         overflow: hidden;
         display: block;
     }
     .hide { display: none; }
    </style>

    <script>
     this.site = () => {
         return STORE.state().get('site');
     };

     this.on('mount', function () {
         Metronome.start();
         ACTIONS.fetchEnvironment('FIRST');
     });

     STORE.subscribe((action)=>{
         if (action.type=='MOVE-PAGE') {
             let tags= this.tags;

             tags['menu-bar'].update();
             ROUTER.switchPage(this, this.refs['page-area'], this.site());
         }

         if (action.type=='FETCHED-ENVIRONMENT' && action.mode=='FIRST')
             ACTIONS.fetchGraph('FIRST');

         if (action.type=='FETCHED-GRAPH' && action.mode=='FIRST')
             ACTIONS.fetchEr(action.mode);

         if (action.type=='FETCHED-ER' && action.mode=='FIRST')
             ACTIONS.fetchTer(action.mode);

     })

     window.addEventListener('resize', (event) => {
         this.update();
     });

     if (location.hash=='')
         location.hash='#page01'
    </script>
</app>
