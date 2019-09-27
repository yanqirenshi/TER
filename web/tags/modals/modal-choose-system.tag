<modal-choose-system>

    <div class="modal {isActive()}">
        <div class="modal-background"></div>

        <div class="modal-card">

            <header class="modal-card-head">
                <p class="modal-card-title">Choose System</p>

                <button class="delete"
                        aria-label="close"
                        onclick={clickClose}></button>
            </header>

            <section class="modal-card-body">

                <modal-choose-system-selected source={selectedSystem()}></modal-choose-system-selected>

                <h1 class="title is-4">System List</h1>

                <modal-choose-system-list source={list()}
                                          callback={callback}></modal-choose-system-list>

            </section>

            <footer class="modal-card-foot">
                <button class="button"
                        onclick={clickClose}>Cancel</button>

                <button class="button is-success"
                        onclick={clickCreate}>Select</button>
            </footer>

        </div>
    </div>

    <script>
     this.selected_system = null;
     this.callback = (action, data) => {
         if (action=='select-item') {
             let id = data;
             this.selected_system = STORE.get('systems.ht')[id];
             this.update();

             return;
         }
     };
    </script>

    <script>
     this.list = () => {
         return STORE.get('systems.list') || [];
     }
     this.selectedSystem = () => {
         if (this.selected_system)
             return this.selected_system;

         let id = STORE.get('active.system')._id;

         let system = STORE.get('systems.list').find((d)=>{
             return d._id == id;
         })

         if (!system)
             'Please select System....';

         return system;
     };
    </script>

    <script>
     this.clickClose = () => {
         ACTIONS.closeModalChooseSystem();
     };
     this.clickCreate = () => {
         let system = this.selectedSystem();

         ACTIONS.changeSystem(system);
     };
     this.isActive = () => {
         return STORE.get('modals.choose-system') ? 'is-active' : '';
     };
     STORE.subscribe((action) =>{
         if (action.type=='OPEN-MODAL-CHOOSE-SYSTEM') {
             this.update();
             return;
         }
         if (action.type=='CLOSE-MODAL-CHOOSE-SYSTEM') {
             this.update();
             return;
         }
         if (action.type=='CHANGE-SYSTEM') {
             this.clickClose();
             return;
         }
     });
    </script>

    <style>
     modal-choose-system .modal-card-foot {
         display: flex;
         justify-content: space-between;
     }
     modal-choose-system .modal-card-body .input,
     modal-choose-system .modal-card-body .select {
         margin-bottom: 11px;
     }
    </style>

</modal-choose-system>
