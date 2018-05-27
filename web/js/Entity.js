class Entity {
    constructor() {
        this._conf = {
            base: {
                padding: 11
            },
            header: {
                padding: { bottom: 3}
            },
            body: {
                padding: {
                    top: 3,
                    center: 3
                }
            }
        };
    }
    ///// ////////////////////////////////////////
    /////  Sizing
    ///// ////////////////////////////////////////
    /// header
    headerWidth (d) {
        let padding = this._conf.base.padding;
        return this.baseWidth(d) - padding * 2;
    }
    headerContentsHight (d) {
        return 22;
    }
    headerHight (d) {
        let padding_top = this._conf.base.padding;
        let padding_bottm = this._conf.header.padding.bottom;
        return 22 + padding_top + padding_bottm;
    }
    /// body area
    bodyY (d) {
        let padding_top = this._conf.body.padding.top;
        return d.y + this.headerHight(d) + padding_top;
    }
    bodyContetnsWidth (d) {
        let padding = this._conf.base.padding;
        return this.baseWidth(d) - (padding * 2);
    }
    bodyContentsHeight (d) {
        let padding_top = this._conf.body.padding.top;
        let padding_bottm = this._conf.base.padding;
        return this.leftAreaHeight(d) - padding_top - padding_bottm;
    }
    /// left area
    leftAreaX (d) {
        let padding = this._conf.base.padding;
        return d.x + padding;
    }
    leftAreaWidth (d) {
        return Math.floor(this.bodyContetnsWidth(d) / 2);

    }
    leftAreaContentsWidth (d) {
        let padding_left = this._conf.body.padding.center;

        return this.leftAreaWidth(d) - padding_left;
    }
    leftAreaHeight (d) {
        return this.baseHeight(d) - this.headerHight(d);
    }
    /// right area
    rightAreaX (d) {
        let padding = this._conf.base.padding;
        let padding_left = this._conf.body.padding.center;

        return Math.floor(this.bodyContetnsWidth(d)/2)
            + padding // base の
            + padding_left; // body-right の padding
    }
    rightAreaWidth (d) {
        return Math.floor(333/2);
    }
    rightAreaHeight (d) {
        return this.baseHeight(d);
    }
    /// base
    baseWidth (d) {
        return 333;
    }
    baseHeight (d) {
        return 222;
    }
    ///// ////////////////////////////////////////
    /////  Draw
    ///// ////////////////////////////////////////
    drawHeader (g) {
        let padding = this._conf.base.padding;
        let self = this;
        g.append('rect')
            .attr('class', 'header')
            .attr('x', function (d) { return d.x + padding; })
            .attr('y', function (d) { return d.y + padding; })
            .attr('width',  (d) => { return this.headerWidth(d); })
            .attr('height', (d) => { return this.headerContentsHight(d); })
            .attr('fill', '#fefefe')
            .attr('stroke-width', 0.3)
            .attr('stroke', '#eeeeee');

        g.append('text')
            .attr('class', 'header')
            .attr('x', function (d) { return d.x + padding + 6; })
            .attr('y', function (d) { return d.y + padding + 16; })
            .attr('font-size', 16 + 'px')
            .text((d) => { return d.name; });
    }
    drawLeftArea (g) {
        let self = this;
        g.append('rect')
            .attr('class', 'header')
            .attr('x', (d)=>{ return this.leftAreaX(d); })
            .attr('y', (d)=>{ return this.bodyY(d); })
            .attr('width',  (d)=>{ return this.leftAreaContentsWidth(d); })
            .attr('height', (d)=>{ return this.bodyContentsHeight(d); })
            .attr('fill', '#fefefe')
            .attr('stroke-width', 0.3)
            .attr('stroke', '#eeeeee');
    }
    drawRightArea (g) {
        let self = this;
        g.append('rect')
            .attr('class', 'header')
            .attr('x', (d)=>{ return this.rightAreaX(d); })
            .attr('y', (d)=>{ return this.bodyY(d); })
            .attr('width',  (d)=>{ return this.leftAreaContentsWidth(d); })
            .attr('height', (d)=>{ return this.bodyContentsHeight(d); })
            .attr('fill', '#fefefe')
            .attr('stroke-width', 0.3)
            .attr('stroke', '#eeeeee');
    }
    drawBase (g) {
        g.append('rect')
            .attr('class', 'base')
            .attr('x', (d) => { return d.x; })
            .attr('y', (d) => { return d.y; })
            .attr('width', (d) => { return this.baseWidth(); })
            .attr('height', (d) => { return this.baseHeight(); })
            .attr('fill', '#f8f8f8')
            .attr('stroke-width', 0.3)
            .attr('stroke', '#eeeeee')
;
    }
    drawG (d3svg, nodes) {
        let svg = d3svg._svg;
        return svg.selectAll('g.entity')
            .data(nodes)
            .enter()
            .append('g')
            .attr('class', 'entity');

    }
    drawNodes (d3svg, state) {
        let g = this.drawG(d3svg, state.nodes.list);
        this.drawBase(g);
        this.drawLeftArea(g);
        this.drawRightArea(g);
        this.drawHeader(g);
    }
    drawEdges (d3svg, state) {}
    draw (d3svg, state) {
        this.drawNodes(d3svg, state);
        this.drawEdges(d3svg, state);
    }
}
