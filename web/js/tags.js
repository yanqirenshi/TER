riot.tag2('app', '<page01 class="page"></page01> <page02 class="page"></page02> <page03 class="page"></page03>', 'app > .page { width: 100vw; height: 100vh; overflow: hidden; display: block; }', '', function(opts) {
     window.addEventListener('resize', (event) => {
         this.update();
     });

     this.on('mount', function () {
         Metronome.start();
     });
});

riot.tag2('page01', '<svg ref="svg-tag"></svg>', '', 'ref="self"', function(opts) {
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
});

riot.tag2('page02', '', '', '', function(opts) {
});

riot.tag2('page03', '', '', '', function(opts) {
});
