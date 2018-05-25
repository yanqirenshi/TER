class Entity {
    constructor() {
        this._conf = {
            base: {
                padding: 11
            }
        };
    }
    ///// ////////////////////////////////////////
    /////  Sizing
    ///// ////////////////////////////////////////
    /// header
    headerWidth (d) {
        return this.baseWidth(d);
    }
    headerContentsHight (d) {
        return 22;
    }
    headerHight (d) {
        let padding_top = this._conf.base.padding;
        let padding_bottm = 3;
        return 22 + padding_top + padding_bottm;
    }
    /// left area
    leftAreaWidth (d) {
        return Math.floor(333/2);
    }
    leftAreaHeight (d) {
        return this.baseHeight(d);
    }
    /// right area
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
    drawHeader (g) {}
    drawLeftArea (g) {}
    drawRightArea (g) {}
    drawBase (g) {
        g.append('rect')
            .attr('class', 'base')
            .attr('x', (d) => { return d.x; })
            .attr('y', (d) => { return d.y; })
            .attr('width', (d) => { return this.baseWidth(); })
            .attr('height', (d) => { return this.baseHeight(); })
            .attr('fill', '#f8f8f8');
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
