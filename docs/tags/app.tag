<app>
    <github-link fill="#CF2317" color="#1D0C37"
                 href="https://github.com/yanqirenshi/TER"></github-link>

    <menu-bar brand={{label:'RT'}} site={site()} moves={[]}></menu-bar>

    <div ref="page-area" style="margin-left:55px;"></div>

    <style>
     app > .page {
         width: 100vw;
         overflow: hidden;
         display: block;
     }
     .hide { display: none; }
    </style>

    <script>
     this.site = () => {
         return STORE.state().get('site');
     };

     STORE.subscribe((action)=>{
         if (action.type!='MOVE-PAGE')
             return;

         let tags= this.tags;

         tags['menu-bar'].update();
         ROUTER.switchPage(this, this.refs['page-area'], this.site());
     })

     window.addEventListener('resize', (event) => {
         this.update();
     });

     if (location.hash=='')
         location.hash=STORE.get('site.active_page');
    </script>
</app>
