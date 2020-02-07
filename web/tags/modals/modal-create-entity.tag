<modal-create-entity>

    <div class="modal {isActive()}">
        <div class="modal-background"></div>

        <div class="modal-card">

            <header class="modal-card-head">
                <p class="modal-card-title">Create Entity</p>

                <button class="delete"
                        aria-label="close"
                        onclick={clickClose}></button>
            </header>

            <section class="modal-card-body">

                <div class="select">
                    <select ref="entity_type" onchange={keyUp}>
                        <option value="">Entity の種類を選択してください。</option>
                        <option value="rs">Resource</option>
                        <option value="ev">Event</option>
                    </select>
                </div>

                <input class="input"
                       type="text"
                       placeholder="Code"
                       ref="code"
                       onkeyup={keyUp}>

                <input class="input"
                       type="text"
                       placeholder="Name"
                       ref="name"
                       onkeyup={keyUp}>

                <textarea class="textarea"
                          placeholder="Description"
                          ref="description"></textarea>

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
     this.clickClose = () => {
         ACTIONS.closeModalCreateEntity();
     };
     this.clickCreate = () => {
         let state = STORE.get('active');
         ACTIONS.createTerEntity(
             state.system,
             state.ter.campus,
             {
                 type: this.refs.entity_type.value,
                 code: this.refs.code.value.trim(),
                 name: this.refs.name.value.trim(),
                 description: this.refs.description.value.trim(),
             })
     };
     this.isActive = () => {
         return STORE.get('modals.create-entity') ? 'is-active' : '';
     };
     this.isCanNotCreate = () => {
         if (this.refs.entity_type.value.length==0)
             return true;

         if (this.refs.code.value.trim().length==0)
             return true;

         if (this.refs.name.value.trim().length==0)
             return true;

         return false;
     };
     this.keyUp = () => {
         this.update();
     };
     STORE.subscribe((action)=>{
         if (action.type=='OPEN-MODAL-CREATE-ENTITY') {
             this.update();
             return;
         }
         if (action.type=='CLOSE-MODAL-CREATE-ENTITY') {
             this.update();
             return;
         }
         if (action.type=='CREATED-ENTITY') {
             ACTIONS.closeModalCreateEntity();
             return;
         }
     });
    </script>

    <style>
     modal-create-entity .modal-card-foot {
         display: flex;
         justify-content: space-between;
     }
     modal-create-entity .modal-card-body .input,
     modal-create-entity .modal-card-body .select {
         margin-bottom: 11px;
     }
    </style>

</modal-create-entity>
