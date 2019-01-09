<page02-sec_root>
    <svg id="page02-sec_root-svg" ref="svg"></svg>

    <script>
     this.d3svg = null;
     this.svg   = null;

     this.ter = new Ter();

     this.draw = () => {
         let forground = this.svg.selectAll('g.base.forground');
         let background = this.svg.selectAll('g.base.background');
         let state     = STORE.get('ter');

         new Entity()
             .data(state)
             .sizing()
             .positioning()
             .draw(forground, background);
     };

     this.makeBases = (d3svg) => {
         let svg = d3svg.Svg();

         let base = [
             { _id: -10, code: 'background' },
             { _id: -15, code: 'forground' },
         ];

         svg.selectAll('g.base')
            .data(base, (d) => { return d._id; })
            .enter()
            .append('g')
            .attr('class', (d) => {
                return 'base ' + d.code;
            });
     }
     this.makeD3Svg = () => {
         let w = window.innerWidth;
         let h = window.innerHeight;

         let svg_tag = this.refs['svg'];
         svg_tag.setAttribute('height',h);
         svg_tag.setAttribute('width',w);

         let d3svg = new D3Svg({
             d3: d3,
             svg: d3.select("#page02-sec_root-svg"),
             x: 0,
             y: 0,
             w: w,
             h: h,
             scale: 1
         });

         this.makeBases(d3svg);

         return d3svg;
     }
     STORE.subscribe((action) => {
         if(action.type=='FETCHED-ER-EDGES' && action.mode=='FIRST') {
             this.draw();
         }
     });

     this.on('mount', () => {
         this.d3svg = this.makeD3Svg();
         this.svg = this.d3svg.Svg();
     });
    </script>
</page02-sec_root>
