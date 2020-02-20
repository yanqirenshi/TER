<inspector-entity-basic>
    <div style="margin-top:22px;">
        <table class="table is-bordered is-narrow is-hoverable ter-table"">
            <tbody>
                <tr>
                    <th>Type</th>
                    <td>{dataType()}</td>
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
    </div>

    <div class="description">
        <h1 class="title is-6" style="margin-bottom: 8px;">
            Description
        </h1>

        <div class="contents">
            <div ref="description">
            </div>
        </div>
    </div>

    <div>
        <button class="button is-small" style="width:100%;">Edit</button>
    </div>

    <script>
     this.on('update', () => {
         this.refs.description.innerHTML = marked(this.description() || '');
     });
     this.description = () => {
         let data = this.opts.entity;

         if (!data || !data.description)
             return '';

         return data.description.contents;
     };
     this.entityName = () => {
         let data = this.opts.entity;

         if (!data) return '';

         return data._core.name;
     }
     this.dataType = () => {
         let data = this.opts.entity;

         if (!data) return '';

         return data._class;
     }

     this.entityCode = () => {
         let data = this.opts.entity;

         if (!data) return '';

         return data._core.code;
     }
    </script>

    <style>
     inspector-entity-basic {
         display:block;
         height: 100%;
         max-width: 100%;

         display: flex;
         flex-direction: column;
     }
     inspector-entity-basic .description {
         margin-top: 22px;
         flex-grow: 1;

         display: flex;
         flex-direction: column;
     }
     inspector-entity-basic .description .contents {
         flex-grow: 1;

         width: 100%;
         overflow: auto;
     }
    </style>
</inspector-entity-basic>
