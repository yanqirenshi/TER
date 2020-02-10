<modal-create-system>

    <div class="modal {isActive()}">
        <div class="modal-background"></div>

        <div class="modal-card">

            <header class="modal-card-head">
                <p class="modal-card-title">Create System</p>

                <button class="delete"
                        aria-label="close"
                        onclick={clickClose}></button>
            </header>

            <section class="modal-card-body">

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
         ACTIONS.closeModalCreateRelationship();
     };
     this.clickCreate = () => {
         ACTIONS.createSystem({
             code: this.refs.code.value.trim(),
             name: this.refs.name.value.trim(),
             description: this.refs.description.value.trim(),
         })
     };
     this.isActive = () => {
         return STORE.get('modals.create-system') ? 'is-active' : '';
     };
     this.isCanNotCreate = () => {
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
         if (action.type=='OPEN-MODAL-CREATE-SYSTEM') {
             this.update();
             return;
         }
         if (action.type=='CLOSE-MODAL-CREATE-SYSTEM') {
             this.update();
             return;
         }
         if (action.type=='CREATED-SYSTEM') {
             ACTIONS.closeModalCreateSystem();
             return;
         }
     });
    </script>

    <style>
     modal-create-system .modal-card-foot {
         display: flex;
         justify-content: space-between;
     }
     modal-create-system .modal-card-body .input {
         margin-bottom: 11px;
     }
    </style>

</modal-create-system>
