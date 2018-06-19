<page03-sec_root>
    <svg></svg>

    <script>
     this.d3svg = null;
     this.ter = new Ter();

     this.draw = () => {
         this.d3svg = this.ter.makeD3svg('page03-sec_root > svg');

         this.ter.drawTables(
             this.d3svg,
             STORE.state().get('er')
         );
     }

     STORE.subscribe((action) => {
         if (action.type=='FETCHED-ER' && action.mode=='FIRST')
             this.draw();
     });
    </script>
</page03-sec_root>
