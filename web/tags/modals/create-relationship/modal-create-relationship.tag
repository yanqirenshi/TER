<modal-create-relationship>

    <div class="modal {isActive()}">
        <div class="modal-background"></div>

        <div class="modal-card">

            <header class="modal-card-head">
                <p class="modal-card-title">Create Relationship</p>

                <button class="delete"
                        aria-label="close"
                        onclick={clickClose}></button>
            </header>

            <section class="modal-card-body">

                <div style="display:flex;">

                    <div style="width: 333px;">
                        <modal-create-relationship-entitiy-selector position="from"
                                                                    callback={callback}
                                                                    source={state}>
                        </modal-create-relationship-entitiy-selector>
                    </div>

                    <div style="width: 333px; margin-left:11px; margin-right:11px;">
                        <modal-create-relationship-entitiy-selector position="to"
                                                                    callback={callback}
                                                                    source={state}>
                        </modal-create-relationship-entitiy-selector>
                    </div>

                    <div style="width: 333px;">
                        <modal-create-relationship-type-selector callback={callback}
                                                                 source={state}>
                        </modal-create-relationship-type-selector>
                    </div>

                </div>

            </section>

            <footer class="modal-card-foot">
                <button class="button"
                        onclick={clickClose}>Cancel</button>

                <button class="button is-success"
                        disabled={isCanNotCreate()}
                        onclick={clickCreate}>Create</button>
            </footer>

        </div>
    </div>

    <script>
     this.state = {
         from: null,
         to: null,
         type: null,
     };
     this.callback = (action, data) => {
         if ('change-entity'===action ) {
             this.state[data.position] = data.entity
             this.update();
             return;
         }
         if ('change-type'===action ) {
             this.state.type = data
             this.update();
             return;
         }
     };
    </script>

    <script>
     this.clickClose = () => {
         ACTIONS.closeModalCreateRelationship();
     };
     this.clickCreate = () => {
         let data = STORE.get('modals.create-relationship');

         ACTIONS.createTerRelationship(
             data.system,
             data.campus,
             {
                 from: this.state.from._id,
                 to:   this.state.to._id,
                 type: this.state.type.code,
             });
     };
     this.isActive = () => {
         return STORE.get('modals.create-relationship') ? 'is-active' : '';
     };
     this.isCanNotCreate = () => {
         let state = this.state;

         return !(state.from && state.to && state.type)
     };
     this.keyUp = () => {
         this.update();
     };
     STORE.subscribe((action)=>{
         if (action.type=='OPEN-MODAL-CREATE-RELATIONSHIP') {
             this.update();
             return;
         }
         if (action.type=='CLOSE-MODAL-CREATE-RELATIONSHIP') {
             this.update();
             return;
         }
         if (action.type=='CREATED-RELATIONSHIP') {
             this.clickClose();
             return;
         }
     });
    </script>

    <style>
     modal-create-relationship .modal-card-foot {
         display: flex;
         justify-content: space-between;
     }
     modal-create-relationship .modal-card-body .input {
         margin-bottom: 11px;
     }
    </style>

</modal-create-relationship>
