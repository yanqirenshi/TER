<page01 ref="self">

    <svg></svg>

    <script>
     this.d3svg = null;

     this.random = (type) => {
         let min;
         let max;

         if (type=='x') {
             min = 11;
             max = this.refs.self.clientWidth - 11;
         }
         if (type=='y') {
             min = 11;
             max = this.refs.self.clientHeight - 11;
         }
         return Math.floor( Math.random() * (max + 1 - min) ) + min ;
     }

     this.drawTables = () => {
         let table = new Table();

         let data = STORE.state().get('er').tables.list;
         table.draw(this.d3svg, data);
     };

     STORE.subscribe((action) => {
         if(action.type=='FETCHED-ER-TABLES')
             this.drawTables();
     });

     this.on('mount', () => {
         this.d3svg = new D3Svg({
             d3: d3,
             svg: d3.select("page01 > svg"),
             x: 0,
             y: 0,
             w: this.refs.self.clientWidth,
             h: this.refs.self.clientHeight,
             scale: 1
         });
     });
    </script>
</page01>
