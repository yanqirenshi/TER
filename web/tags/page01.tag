<page01 ref="self">

    <svg ref="svg-tag"></svg>

    <script>
     this.d3svg = null;

     this.on('mount', () => {
         this.d3svg = new D3Svg({
             d3: d3,
             svg: d3.select("stage svg"),
             x: 0,
             y: 0,
             w: this.refs.self.clientWidth,
             h: this.refs.self.clientHeight,
             scale: 1
         });
     });
    </script>
</page01>
