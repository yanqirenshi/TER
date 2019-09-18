<menu-bar-popup>

    <div class="flex-root">
        <div>
            <h1 class="title is-4">System</h1>
        </div>

        <div style="flex-grow:1;">
            <button each={opts.source}
                    class="button system-item"
                    code={code}
                    onclick={clickMovePanelItem}>
                {label}
            </button>
        </div>

        <div>
            <button class="button is-danger"
                    style="width:100%;"
                    onclick={clickCreateSystem}>Create System</button>
        </div>
    </div>

    <script>
     this.clickCreateSystem = () => {
         ACTIONS.openModalCreateSystem();

         ACTIONS.closeGlobalMenuSystemPanel();
     };
     this.clickMovePanelItem = (e) => {
         this.opts.callback('click-move-panel-item', e);

         ACTIONS.closeGlobalMenuSystemPanel();
     };
    </script>

    <style>
     menu-bar-popup .flex-root {
         display: flex;
         flex-direction: column;
         height:100%;
         padding: 22px 22px 11px 22px;
     }


     menu-bar-popup .flex-root .system-item {
         margin-top: 11px;
         width: 100%;
     }

    </style>

</menu-bar-popup>
