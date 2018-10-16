<app>
    <github-link href="https://github.com/yanqirenshi/TER" fill="#5BBBE7" color="#ffffff"></github-link>

    <menu-bar brand={brand()}
              site={site()}
              moves={moves()}
              data={menuBarData()}
              callback={callback}></menu-bar>

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
     this.brand = () => {
         let brand = this.getActiveSchema();

         return { label: (brand ? brand.code : 'TER')};
     };

     this.callback = (type, e) => {
         if (type=='click-brand')
             return STORE.dispatch(ACTIONS.toggleMovePagePanel());

         if (type=='click-move-panel-item')
             return this.clickSchema(e);
     };

     this.clickSchema = (e) => {
         let schema_code = e.target.getAttribute('CODE');

         STORE.dispatch(ACTIONS.changeSchema(schema_code));

         ACTIONS.fetchErNodes(this.getActiveSchema());
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
     this.menuBarData = () => {
         return STORE.state().get('global').menu;
     };

     this.on('mount', function () {
         Metronome.start();
         ACTIONS.fetchEnvironment('FIRST');
     });

     this.getActiveSchema = () => {
         let state = STORE.state().get('schemas');
         let code = state.active;

         return state.list.find((d) => { return d.code == code; });
     };

     STORE.subscribe((action) => {
         if (action.type=='MOVE-PAGE') {
             let tags= this.tags;

             tags['menu-bar'].update();
             ROUTER.switchPage(this, this.refs['page-area'], this.site());
         }

         if (action.type=='FETCHED-ENVIRONMENT' && action.mode=='FIRST') {
             this.tags['menu-bar'].update();
             ACTIONS.fetchGraph('FIRST');
         }

         if (action.type=='FETCHED-GRAPH' && action.mode=='FIRST')
             ACTIONS.fetchErNodes(this.getActiveSchema(), action.mode);

         if (action.type=='FETCHED-ER-NODES')
             ACTIONS.fetchErEdges(this.getActiveSchema(), action.mode);

         if (action.type=='FETCHED-ER-EDGES' && action.mode=='FIRST')
             ACTIONS.fetchTer(action.mode);

         if (action.type=='CHANGE-SCHEMA') {
             ACTIONS.saveConfigAtDefaultSchema(action.data.schemas.active);
             return;
         }

         if (action.type=='CLOSE-ALL-SUB-PANELS' || action.type=='TOGGLE-MOVE-PAGE-PANEL' )
             this.tags['menu-bar'].update();
     })

     window.addEventListener('resize', (event) => {
         this.update();
     });

     if (location.hash=='')
         location.hash='#page01'
    </script>
</app>
