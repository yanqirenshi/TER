<page-ter-controller>

    <button class="button"
            onclick={clickCreateEntity}>
        Create Entity
    </button>

    <button class="button"
            onclick={clickCreateRelationship}>
        Create Relationship
    </button>

    <button class="button"
            onclick={clickSaveGraph}>
        Save Graph
    </button>

    <button class="button"
            onclick={clickDownload}>
        Download
    </button>

    <script>
     this.clickCreateRelationship = () => {
         let state = STORE.get('active');
         let system = state.system;
         let campus = state.ter.campus;

         ACTIONS.openModalCreateRelationship({
             system: system,
             campus: campus,
         });
     };
     this.clickSaveGraph = () => {
         let state = STORE.get('active');
         let system = state.system;
         let campus = state.ter.campus;

         ACTIONS.saveTerCampusGraph(system, campus);
     };
     this.clickDownload = () => {
         let ter = new Ter();
         let file_name = STORE.get('schemas.active') + '.ter';

         ter.downloadJson(file_name,
                          ter.stateTER2Json(STORE.state().get('ter')));
     };
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
