<page-ter-controller>

    <button class="button"
            onclick={clickCreateEntity}>Create Entity</button>

    <button class="button">Create Relationship</button>

    <button class="button">Save Graph</button>

    <button class="button">Download</button>

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
