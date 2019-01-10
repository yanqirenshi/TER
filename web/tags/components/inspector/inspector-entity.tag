<inspector-entity>

    <div>
        <h1 class="title is-5">{entityName()}</h1>
    </div>

    <div style="margin-top:22px;">
        <h1 class="title is-6">基本情報</h1>
        <p>{dataType()}</p>
        <p>{entityCode()}</p>
        <p>{entityName()}</p>
    </div>

    <div style="margin-top:22px;">
        <h1 class="title is-6">Ports</h1>
        <table class="table is-bordered is-striped is-narrow is-hoverable">
            <thead>
                <tr>
                    <th rowspan="3">ID</th>
                    <th colspan="4">Relationship</th>
                    <th colspan="3" rowspan="2">Position</th>
                </tr>
                <tr>
                    <th colspan="2">from</th>
                    <th colspan="2">to</th>
                </tr>
                <tr>
                    <th>entity</th>
                    <th>identifier</th>
                    <th>entity</th>
                    <th>identifier</th>
                    <th>degree</th>
                    <th>x</th>
                    <th>y</th>
                </tr>
            </thead>
            <tbody>
                <tr each={port in portsData()}>
                    <td>{port._core._id}</td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td>{port._core.position}</td>
                    <td>{Math.floor(port.position.x * 100)/100}</td>
                    <td>{Math.floor(port.position.y * 100)/100}</td>
                </tr>
            </tbody>
        </table>
    </div>

    <script>
     this.dataType = () => {
         let data = this.entityData();

         if (!data) return '';

         return data._class;
     }
     this.entityName = () => {
         let data = this.entityData();

         if (!data) return '';

         return data._core.name;
     }
     this.entityCode = () => {
         let data = this.entityData();

         if (!data) return '';

         return data._core.code;
     }
     this.portsData = () => {
         let data = this.entityData();

         if (!data || !data.ports || data.ports.items.list.length==0)
             return null;

         return data.ports.items.list;
     };
     this.entityData = () => {
         let data = this.opts.source;

         if (!data) return null;

         if (data._class=='RESOURCE' || data._class=='EVENT' || data._class=='COMPARATIVE')
             return data;

         return null;
     };
    </script>
</inspector-entity>
