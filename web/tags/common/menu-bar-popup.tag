<menu-bar-popup>

    <div class="flex-root">
        <div>
            <h1 class="title is-4">System</h1>
        </div>

        <div style="flex-grow:1;">
            <button each={obj in opts.source}
                    class="button system-item"
                    id={obj._id}
                    code={obj.code}
                    onclick={clickMovePanelItem}>
                {obj.label}
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
         let id = e.target.getAttribute('id');

         let system = opts.source.find((d) => {
             return d._id == id;
         });

         this.opts.callback('change-system', system._core);

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
