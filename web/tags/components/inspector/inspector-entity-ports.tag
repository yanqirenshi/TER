<inspector-entity-ports>
    <h1 class="title is-6">Ports</h1>
    <inspector-entity-ports-relationships ports={portsData()}></inspector-entity-ports-relationships>
    <inspector-entity-ports-positions     ports={portsData()}></inspector-entity-ports-positions>

    <script>
     this.portsData = () => {
         let data = this.opts.entity;

         if (!data || !data.ports || data.ports.items.list.length==0)
             return null;

         return data.ports.items.list;
     };
    </script>

    <style>
     inspector-entity-ports {
         display: block;
     }
    </style>
</inspector-entity-ports>
