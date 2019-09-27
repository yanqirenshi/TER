<app>
    <github-link fill="#1D0C37" color="#CF2317"
                 href="https://github.com/yanqirenshi/TER"></github-link>


    <app-global-menu brand={brand()}
                     source={site()}></app-global-menu>

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

         this.updateMenuBar();
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
     this.updateMenuBar = () => {
         let menubar = this.tags['app-global-menu'];
         if (menubar)
             menubar.update();
     };
     this.site = () => {
         return STORE.state().get('site');
     };

     this.menuBarData = () => {
         return STORE.state().get('global').menu;
     };

     STORE.subscribe((action) => {
         if (action.type=='CHANGE-SYSTEM') {
             this.update();
             return;
         }

         if (action.type=='MOVE-PAGE') {
             this.updateMenuBar();

             this.tags['app-page-area'].update({ opts: { route: action.route }});
             return;
         }

         if (action.type=='FETCHED-ENVIRONMENTS' && action.mode=='FIRST') {
             this.updateMenuBar()
             return;
         }

         if (action.type=='CLOSE-ALL-SUB-PANELS' ||
             action.type=='TOGGLE-MOVE-PAGE-PANEL' ||
             action.type=='OPEN-GLOBAL-MENU-SYSTEM-PANEL' ||
             action.type=='CLOSE-GLOBAL-MENU-SYSTEM-PANEL') {
             this.updateMenuBar()
             return;
         }
     })

     window.addEventListener('resize', (event) => {
         this.update();
     });

     if (location.hash=='')
         location.hash='#' + STORE.get('site.home_page');
    </script>
</app>
