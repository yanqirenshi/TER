<app>
    <menu-bar brand={{label:'TER'}} site={site()} moves={moves()} callback={clickSchema}></menu-bar>

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
     this.clickSchema = (e) => {
         dump(e.target.getAttribute('CODE'));
     };
     this.moves = () => {
         let schemas = STORE.state().get('schemas').list;
         return schemas.map((d) => {
             return { code: d.code, href: '', label: d.code }
         });
     };
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

         if (action.type=='FETCHED-GRAPH' && action.mode=='FIRST') {
             let state = STORE.state().get('schemas');
             let _id = state.active;
             let schema = state.list.find((d) => { return d._id = _id; });

             ACTIONS.fetchEr(schema, action.mode);
         }

         if (action.type=='FETCHED-ER' && action.mode=='FIRST') {
             ACTIONS.fetchTer(action.mode);
         }

     })

     window.addEventListener('resize', (event) => {
         this.update();
     });

     if (location.hash=='')
         location.hash='#page01'
    </script>
</app>
