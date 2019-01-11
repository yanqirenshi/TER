<inspector-entity>
    <div>
        <h1 class="title is-5">{entityName()}</h1>
    </div>

    <inspector-entity-basic entity={entityData()}></inspector-entity-basic>
    <inspector-entity-ports entity={entityData()}></inspector-entity-ports>

    <script>
     this.entityName = () => {
         let data = this.entityData();

         if (!data) return '';

         return data._core.name;
     }
     this.entityData = () => {
         let data = this.opts.source;

         if (!data) return null;

         if (data._class=='RESOURCE' || data._class=='EVENT' || data._class=='COMPARATIVE')
             return data;

         return null;
     };
    </script>
</inspector-entity>
