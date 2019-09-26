<app>
    <github-link fill="#1D0C37" color="#CF2317"
                 href="https://github.com/yanqirenshi/TER"></github-link>


    <menu-bar brand={brand()}
              site={site()}
              systems={systems()}
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
     this.brand = () => {
         let brand = STORE.get('active.system');

         return { label: (brand ? brand.code : 'TER')};
     };

     this.callback = (type, e) => {
         if (type=='click-brand')
             return ACTIONS.toggleMovePagePanel();

         if (type=='change-system')
             return this.changeSystem(e);
     };

     this.changeSystem = (system) => {
         ACTIONS.changeSystem(system);

         this.tags['menu-bar'].update();
     };

     this.systems = () => {
         let systems = STORE.get('systems.list');

         return systems.map((d) => {
             return {
                 _id: d._id,
                 code: d.code,
                 href: '',
                 label: d.code,
                 description: d.description,
                 _core: d,
             }
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

         if (action.type=='FETCHED-ENVIRONMENTS' && action.mode=='FIRST')
             this.tags['menu-bar'].update();

         if (action.type=='CLOSE-ALL-SUB-PANELS' ||
             action.type=='TOGGLE-MOVE-PAGE-PANEL' ||
             action.type=='OPEN-GLOBAL-MENU-SYSTEM-PANEL' ||
             action.type=='CLOSE-GLOBAL-MENU-SYSTEM-PANEL')
             this.tags['menu-bar'].update();
     })

     window.addEventListener('resize', (event) => {
         this.update();
     });

     if (location.hash=='')
         location.hash='#' + STORE.get('site.home_page');
    </script>
</app>
