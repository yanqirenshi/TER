<inspector-entity-basic>
    <div style="margin-top:22px;">
        <h1 class="title is-6">基本情報</h1>
        <table class="table is-bordered is-narrow is-hoverable">
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

    <script>
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
</inspector-entity-basic>
