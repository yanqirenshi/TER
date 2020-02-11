<modal-add-attribute-2-entity_entity>

    <h1 class="title is-4" style="margin-bottom: 8px;">Entity</h1>

        <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
            <tbody>
                <tr>
                    <th>Type</th>
                    <td>{entityType()}</td>
                </tr>
                <tr>
                    <th>Code</th>
                    <td>{entityCode()}</td>
                </tr>
                <tr>
                    <th>Name</th>
                    <td>{entityName()}</td>
                </tr>
            </tbody>
        </table>

        <script>
         this.entityType = () => {
             if (!this.opts || !this.opts.source)
                 return '';

             return this.opts.source._class;
         }
         this.entityCode = () => {
             if (!this.opts || !this.opts.source)
                 return '';

             return this.opts.source._core.code;
         }
         this.entityName = () => {
             if (!this.opts || !this.opts.source)
                 return '';

             return this.opts.source._core.name;
         }
        </script>

</modal-add-attribute-2-entity_entity>
