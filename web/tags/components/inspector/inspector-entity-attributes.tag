<inspector-entity-attributes>

    <div style="margin-top:22px;">

        <table class="table is-bordered is-narrow is-hoverable ter-table ter-table">
            <thead>
                <tr>
                    <th>Code</th>
                    <th>Name</th>
                    <th>Type</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <tr each={attr in list()}>
                    <td>{attr.code}</td>
                    <td>{attr.name}</td>
                    <td>{attr.data_type}</td>
                    <td>
                        <button class="button is-small is-warning" disabled>Edit</button>
                        <button class="button is-small is-danger" disabled>Delete</button>
                    </td>
                </tr>
            </tbody>
        </table>

        <div style="display:flex;justify-content: flex-end;">
            <button class="button is-primary" onclick={clickAdd}>Add</button>
        </div>

    </div>

    <script>
     this.clickAdd = () => {
         let state = STORE.get('active');

         ACTIONS.openModalAddAttribute2Entity({
             system: state.system,
             campus: state.ter.campus,
             entity: this.opts.entity,
         });
     };
    </script>

    <script>
     this.list = () => {
         if (!this.opts.entity)
             return [];

         return this.opts.entity.attributes.items.list;
     };
    </script>

</inspector-entity-attributes>
