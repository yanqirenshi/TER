<page02-sec_root>
    <svg></svg>

    <script>
     this.d3svg = null;
     this.ter = new Ter();
     this.entity = new Entity();

     this.drawNodes = (d3svg, state)=>{
         let svg = d3svg._svg;
         let nodes = state.nodes.list;
     };
     this.drawEdges = (d3svg, state)=>{
         let svg = d3svg._svg;
         let nodes = state.nodes.ht;
         let edges = state.edges.list;
     };

     STORE.subscribe((action) => {
         /* if(action.type=='???' && action.mode=='FIRST') {
          *     this.d3svg = this.ter.makeD3svg('page02-sec_root > svg');
          *     new Grid().draw(this.d3svg);

          *     this.entity.draw(this.d3svg, STORE.state().get('ter'))
          * } */
     });
    </script>
</page02-sec_root>
