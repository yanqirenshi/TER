<modal-add-attribute-2-entity>

    <div class="modal {isActive()}">
        <div class="modal-background"></div>

        <div class="modal-card">

            <header class="modal-card-head">
                <p class="modal-card-title">Add Attribute</p>

                <button class="delete"
                        aria-label="close"
                        onclick={clickClose}></button>
            </header>

            <section class="modal-card-body">

                <div style="margin-bottom:22px;">
                    <modal-add-attribute-2-entity_entity source={entity()}>
                    </modal-add-attribute-2-entity_entity>
                </div>

                <div>
                    <modal-add-attribute-2-entity_form source={attribute} callback={callback}>
                    </modal-add-attribute-2-entity_form>
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
     this.attribute = {
         code: '',
         name: '',
         description: '',
         data_type: null
     };
     this.callback = (action, data) => {
         if ('change-data'===action) {
             this.attribute[data.key] = data.val;

             this.update();
             return;
         }
     };
    </script>

    <script>
     this.entity = () => {
         let state = STORE.get('modals.add-attribute-2-entity');

         if (!state)
             return null;

         return state.entity;
     };
    </script>

    <script>
     this.clickClose = () => {
         ACTIONS.closeModalAddAttribute2Entity();
     };
     this.clickCreate = () => {
         let state = STORE.get('modals.add-attribute-2-entity');

         ACTIONS.addTerAttribute2Entity(
             state.system,
             state.campus,
             state.entity,
             {
                 code: this.attribute.code.trim(),
                 name: this.attribute.name.trim(),
                 description: this.attribute.description.trim(),
                 data_type: this.attribute.data_type
             })
     };
     this.isActive = () => {
         return STORE.get('modals.add-attribute-2-entity') ? 'is-active' : '';
     };
     this.isCanNotCreate = () => {
         return this.attribute.code.trim() == '' ||
                this.attribute.name.trim() === '' ||
                this.attribute.data_type === null;
     };
     this.keyUp = () => {
         this.update();
     };
     STORE.subscribe((action)=>{
         if (action.type=='OPEN-MODAL-ADD-ATTRIBUTE-2-ENTITY') {
             this.update();
             return;
         }
         if (action.type=='CLOSE-MODAL-ADD-ATTRIBUTE-2-ENTITY') {
             this.attribute = {
                 code: '',
                 name: '',
                 description: '',
                 data_type: null
             };

             this.update();
             return;
         }
         if (action.type=='ADDED-TER-ATTRIBUTE-2-ENTITY') {
             this.clickClose();
             return;
         }
     });
    </script>

    <style>
     modal-add-attribute-2-entity .modal-card-foot {
         display: flex;
         justify-content: space-between;
     }
     modal-add-attribute-2-entity .modal-card-body .input {
         margin-bottom: 11px;
     }
     modal-add-attribute-2-entity .field:not(:last-child) {
         margin-bottom: 0px;
     }
    </style>

</modal-add-attribute-2-entity>
