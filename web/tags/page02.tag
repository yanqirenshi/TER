<page02>
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
         if(action.type=='FETCHED-TER')
             this.entity.draw(this.d3svg, STORE.state().get('ter'))

         if (action.type=='FETCHED-ENVIRONMENT' && action.mode=='FIRST') {
             this.d3svg = this.ter.makeD3svg('page02 > svg');
             new Grid().draw(this.d3svg);
         }
     });
    </script>
</page02>
