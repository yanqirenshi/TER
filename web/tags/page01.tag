<page01>
    <svg></svg>

    <script>
     this.d3svg = null;
     this.graph = new Graph();

     STORE.subscribe((action) => {
         /* if(action.type=='FETCHED-ER')
          *     this.graph.drawTables(
          *         this.d3svg,
          *         STORE.state().get('er')
          *     );*/
     });

     this.on('mount', () => {
         this.d3svg = this.graph.makeD3svg('page01 > svg');
     });
    </script>
</page01>
