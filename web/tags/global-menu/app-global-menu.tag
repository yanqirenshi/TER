<app-global-menu>

    <div>
        <div class="brand">
            <app-global-menu-brand source={opts.brand}></app-global-menu-brand>
        </div>

        <div class="graphs">
            <app-global-menu-item each={obj in menus.graphs}
                                  source={obj}
                                  active_page_code={activePageCode()}></app-global-menu-item>
        </div>

        <app-global-menu-separator></app-global-menu-separator>

        <div class="finder">
            <app-global-menu-item each={obj in menus.finder}
                                  source={obj}
                                  active_page_code={activePageCode()}></app-global-menu-item>
        </div>

        <app-global-menu-separator></app-global-menu-separator>

        <div class="account" style="padding-bottom: 22px;">
            <app-global-menu-item each={obj in menus.account}
                                  source={obj}
                                  active_page_code={activePageCode()}></app-global-menu-item>
        </div>

    </div>

    <script>
     this.activePageCode = () => {
         return this.opts.source.active_page;
     }
    </script>

    <script>
     this.menus = {
         graphs: [
             { label: 'T字形ER図', code: 'ter' },
             { label: 'ER図',      code: 'er' },
         ],
         finder: [
             { label: 'Systems',     code: 'systems' },
             { label: 'Modelers',    code: 'modelers' },
             { label: 'Managements', code: 'managements' },
         ],
         account: [
             { label: 'Account',  code: 'account' },
         ],
     };
    </script>

    <style>
     app-global-menu > div {
         z-index: 666666;

         display: flex;
         flex-direction: column;

         height: 100vh;
         width: 111px;
         padding: 0px 0px 0px 0px;

         position: fixed;
         left: 0px;
         top: 0px;

         text-align: center;

         background: rgba(29, 12, 55, 0.9);
     }
     app-global-menu > div > .finder {
         flex-grow: 1;
     }
    </style>

</app-global-menu>
