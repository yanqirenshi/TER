<page-ter-controller>

    <button class="button"
            onclick={clickCreateEntity}>Create Entity</button>

    <button class="button">Create Relationship</button>

    <button class="button">Save Graph</button>

    <button class="button" onclick={clickDownload}>Download</button>

    <script>
     this.clickDownload = () => {
         let erapp = new ErApp();
         let file_name = STORE.get('schemas.active') + '.ter';

         erapp.downloadJson(file_name, erapp.stateTER2Json(STORE.state().get('ter')));
     }
    </script>

    <script>
     this.clickCreateEntity = () => {
         ACTIONS.openModalCreateEntity();
     };
    </script>

    <style>
     page-ter-controller {
         position: fixed;
         right: 22px;
         bottom: 22px;
         display: flex;
         flex-direction: column;
     }
     page-ter-controller > * {
         margin-top: 22px;
     }
    </style>

</page-ter-controller>
