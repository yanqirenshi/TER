<app>
    <github-link href="https://github.com/yanqirenshi/TER" fill="#5BBBE7" color="#ffffff"></github-link>

    <menu-bar brand={brand()}
              site={site()}
              moves={moves()}
              data={menuBarData()}
              callback={callback}></menu-bar>

    <app-page-area></app-page-area>

    <modal-pool></modal-pool>

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
     this.getActiveSchema = () => {
         let state = STORE.state().get('schemas');
         let code = state.active;

         return state.list.find((d) => { return d.code == code; });
     };

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

         this.tags['menu-bar'].update();

         ACTIONS.fetchErNodes(this.getActiveSchema());
     };

     this.moves = () => {
         let schemas = STORE.state().get('schemas').list;

         return schemas.map((d) => {
             return { code: d.code, href: '', label: d.code }
         });
     };

     this.on('mount', () => {
         let route = location.hash.substring(1).split('/');

         ACTIONS.movePage({ route: route });
     });

     this.site = () => {
         return STORE.state().get('site');
     };
     this.menuBarData = () => {
         return STORE.state().get('global').menu;
     };

     this.updateMenuBar = () => {
         if (this.tags['menu-bar'])
             this.tags['menu-bar'].update();
     }

     STORE.subscribe((action) => {
         if (action.type=='MOVE-PAGE') {
             this.updateMenuBar();

             this.tags['app-page-area'].update({ opts: { route: action.route }});
         }

         if (action.type=='FETCHED-ENVIRONMENT' && action.mode=='FIRST')
             this.tags['menu-bar'].update();

         if (action.type=='CLOSE-ALL-SUB-PANELS' || action.type=='TOGGLE-MOVE-PAGE-PANEL' )
             this.tags['menu-bar'].update();
     })

     window.addEventListener('resize', (event) => {
         this.update();
     });

     if (location.hash=='')
         location.hash='#base'
    </script>
</app>
