class TerEntity {
    constructor(core, state) {
        this._id = null;
        this._class = null;
        this._core = null;

        this.this.description = { contents: '' };

        this.position = { x:0, y:0, z:0 };

        this.size = { w:0, h:0 };

        this.padding = 11;
        this.margin = 6;

        this.bar = {
            size: {
                header: 11,
                contents: 8,
            }
        };

        this.background = {
            color: '',
        };

        this.name = {
            position: { x:0, y:0, z:0 },
            size: { h: null, w: null },
            padding: 11,
            contents: ''
        };

        this.type = {
            position: { x:0, y:0, z:0 },
            size: { h: null, w: 42 },
            padding: 11,
            size: { w:0, h:0 },
        };

        this.identifiers = {
            position: { x:0, y:0, z:0 },
            padding: 8, // 各項目の一辺の padding 値
            size: { w: null, h: null },
            items: { list: [], ht: {} },
        };

        this.attributes = {
            position: { x:0, y:0, z:0 },
            padding: 8, // 各項目の一辺の padding 値
            size: { w: null, h: null },
            items: { list: [], ht: {} },
        };

        this.ports = {
            items: { list: [], ht: {} },
        };

        this.init(core, state);
    }
    /* **************************************************************** *
     *  Data manegement
     * **************************************************************** */
    entityTypeContents () {
        switch (this._class) {
        case 'RESOURCE':    return 'Rsc';
        case 'COMPARATIVE': return '対象';
        case 'EVENT':       return 'Evt';
        }
        throw new Error(this._class + " は知らないよ。");
    }
    isEntityClass (_class) {
        let classes = ['RESOURCE', 'EVENT'];

        return classes.indexOf(_class) > -1;
    }
    addOut (obj, out)  {
        out.list.push(obj);
        out.ht[obj._id] = obj;
    };
    makeColumnData (core) {
        let obj = Object.assign({}, core);

        obj._core = core;
        obj.position = { x:0, y:0 };
        return obj;
    }
    addIdentifiers (state) {
        let identifiers = state.identifier_instances.ht;
        let relationships = state.relationships.indexes.from[this._id];

        let out = { list: [], ht: {} };

        for (let key in relationships) {
            let r = relationships[key];

            if (r.to_class=='IDENTIFIER-INSTANCE') {
                let core = identifiers[r.to_id];

                core._entity = entity;
                core._parent = this.identifiers;
                this.addOut(this.makeColumnData(core), out);
            }
        }

        this.identifiers.items = out;
    }
    addAttributes (state) {
        let attributes = state.attribute_instances.ht;
        let relationships = state.relationships.indexes.from[this._id];

        let out = { list: [], ht: {} };

        for (let key in relationships) {
            let r = relationships[key];

            if (r.to_class=='ATTRIBUTE-INSTANCE') {
                let core = attributes[r.to_id];

                core._entity = entity;
                core._parent = this.attributes;
                this.addOut(this.makeColumnData(core), out);
            }
        }

        this.attributes.items  = out;
    }
    findEntityPorts (state) {
        let identifiers = this.identifiers.items.list;
        let edges_all = state.relationships.indexes.from;

        let out = [];
        for (let identifier of identifiers) {
            let edges = edges_all[identifier._id];

            if (!edges) continue;

            for (let key in edges) {
                let edge = edges[key];

                if (edge.to_class=='PORT-TER')
                    out.push(edge._to);
            }
        }

        return out;
    }
    addPorts (state) {
        let identifiers = this.identifiers.items.list;
        let edges_all = state.relationships.indexes.from;

        let ports = this.findEntityPorts(state);

        for (let port_core of ports) {
            let items = this.ports.items;
            let port = {
                position: { x:0, y:0 },
                _id: port_core._id,
                _class: port_core._class,
                _core: port_core,
                _entity: this,
            };

            port_core._element = port;

            items.list.push(port);
            items.ht[port._id] = port;
        };
    }
    init (core, state) {
        let toplevs = ['_id', '_class'];
        for (let colkey of toplevs)
            this[colkey] = core[colkey];

        this.name.contents        = core.name;
        this.description.contents = core.description;
        this.position             = Object.assign({}, core.position);
        this.size                 = Object.assign({}, core.size);
        this.type.contents        = core.entityTypeContents();

        this.addIdentifiers(state);
        this.addAttributes(state);
        this.addPorts(state);

        let background_ht = this._default.style.this.background;
        this.background = background_ht[core._class.toLowerCase()];
        this._core = this;

        return this;
    }
    /* **************************************************************** *
     *  Sizing
     * **************************************************************** */
    fitting () {
        this.name.size.w        = Math.ceil(this._max_w.name)       + this.name.padding * 2;
        this.identifiers.size.w = Math.ceil(this._max_w.identifier) + this.identifiers.padding * 2;
        this.attributes.size.w  = Math.ceil(this._max_w.attribute)  + this.attributes.padding * 2;

        let name_area_w =
            this.name.size.w +
            this.bar.size.header +
            this.type.size.w +
            (this.padding * 2);

        let contents_area_w =
            this.identifiers.size.w
            + this.bar.size.contents
            + this.attributes.size.w
            + (this.padding * 2);

        this.size.w = contents_area_w > name_area_w ? contents_area_w : name_area_w;

        // fix size for attr area
        if (this._max_w.attribute==0 || contents_area_w < name_area_w) {
            this.attributes.size.w =
                this.size.w -
                this.identifiers.size.w -
                this.bar.size.contents -
                (this.padding * 2);
        }

        // fix size for name area
        if (contents_area_w > name_area_w) {
            this.name.size.w =
                this.size.w -
                this.bar.size.header -
                this.type.size.w -
                (this.padding * 2);
        }
    }
    sizingType () {
        let data = this.type;

        if (!data.contents)
            data.contents = '??';

        data.size.h = this._default.line.height + data.padding * 2;
        data.size.w = data.contents.length * this._default.line.font.size + data.padding * 2;
    }
    sizingName () {
        let data = this.name;

        if (!data.contents)
            data.contents = '????????';

        data.size.h = this._default.line.height + data.padding * 2;

        let type = this.type;
        let split_bar_size = 11;

        data.size.w = (this.size.w - (this.padding * 2) -
                       this.bar.size.header -
                       type.size.w);
    }
    sizingIdentifiers () {
        let data = this.identifiers;
        let padding = this.padding;

        data.size.w =
            ((this.size.w - (this.padding * 2)) / 2) -
            (this.bar.size.contents / 2);
        data.size.h = data.items.list.length * (this._default.line.height + padding * 2);
    }
    sizingAttributes () {
        let data = this.attributes;
        let padding = this.padding;

        data.size.w =
            ((this.size.w - (this.padding * 2)) / 2) -
            (this.bar.size.contents / 2);
        data.size.h = data.items.list.length * (this._default.line.height + padding * 2);
    }
    sizingContentsArea () {
        let id_h = this.identifiers.size.h;
        let attr_h = this.attributes.size.h;

        if (id_h > attr_h)
            this.attributes.size.h = id_h;
        else
            this.identifiers.size.h = attr_h;
    }
    sizing () {
        this.sizingType();
        this.sizingName();
        this.sizingIdentifiers();
        this.sizingAttributes();
        this.sizingContentsArea();

        let padding = this.padding * 2;
        let header = this.name.size.h;
        let margin = 11;
        let contents = this.attributes.size.h;

        this.size.h = padding + header + margin + contents;

        this.fitting();
    }
    /* **************************************************************** *
     *  Positioning
     * **************************************************************** */
    positioningName () {
        let d = this.name;
        d.position.x = this.padding;
        d.position.y = this.padding;
    }
    positioningType () {
        let d = this.type;
        let margin = 11;
        d.position.x = this.padding + this.name.size.w + margin;
        d.position.y = this.padding;
    }
    positioningColumnItems (identifiers) {
        let len         = identifiers.items.list.length;
        let padding     = identifiers.padding;
        let start       = (identifiers.position.y);
        let line_height = this._default.line.height;
        let item_h      = (line_height + padding * 2);
        let magic_num   = 3; // y軸の微調整係数

        for (let i=0 ; i<len ; i++) {
            let item = identifiers.items.list[i];
            item.position.x = identifiers.position.x + padding;
            item.position.y = start + padding + line_height + i * item_h + magic_num;
        }
    }
    positioningIdentifiers () {
        let d = this.identifiers;
        let margin = 11;

        d.position.x = this.padding;
        d.position.y = this.padding + this.name.size.h + margin;

        this.positioningColumnItems (d);
    }
    positioningAttributes () {
        let d = this.attributes;
        let margin1 = (4 * 2);
        let margin2 = 11;

        d.position.x = this.padding + margin1 + this.identifiers.size.w;
        d.position.y = this.padding + this.name.size.h + margin2;

        this.positioningColumnItems (d);
    }
    deg2rad (degree) {
        return degree * ( Math.PI / 180 );
    }
    getPortLineLength () {
        let max_length = Math.floor(Math.sqrt((this.size.w * this.size.w) + (this.size.h * this.size.h)));

        return 0.8 * max_length;
    }
    getPortLineFrom () {
        return {
            x: Math.floor(this.size.w / 2),
            y: Math.floor(this.size.h / 2)
        };
    }
    makePortLine (port) {
        let out = {
            from: {x:0, y:0},
            to:   {x:0, y:0},
        };

        let from = this.getPortLineFrom();
        out.from.x = from.x;
        out.from.y = from.y;

        let x = 0;
        let y = this.getPortLineLength();

        let degree = port._core.position % 360;

        let radian = this.deg2rad(degree);
        let cos = Math.cos(radian);
        let sin = Math.sin(radian);

        out.to.x = Math.floor(x * cos - y * sin);
        out.to.y = Math.floor(x * sin + y * cos);

        out.to.x += out.from.x;
        out.to.y += out.from.y;

        port._from = out.from;
        port._to   = out.to;

        return out;
    }
    isCorss(A, B, C, D) {
        // 二つの線分の交差チェック
        // https://www.hiramine.com/programming/graphics/2d_segmentintersection.html
        let ACx = C.x - A.x;
        let ACy = C.y - A.y;
        let BUNBO = (B.x - A.x) * (D.y - C.y) - (B.y - A.y) * (D.x - C.x);

        if (BUNBO==0)
            return false;

        let r = ((D.y - C.y) * ACx - (D.x - C.x) * ACy) / BUNBO;
        let s = ((B.y - A.y) * ACx - (B.x - A.x) * ACy) / BUNBO;

        return ((0 <= r && r <= 1) && (0 <= s && s <= 1));
    }
    getCrossPointCore (line, line_port, port) {
        // ２直線の交点を求める公式
        let out = { x:0, y:0 };

        let A = line.from;
        let B = line.to;
        let C = line_port.from;
        let D = line_port.to;

        let bunbo = (B.y - A.y) * (D.x - C.x) - (B.x - A.x) * (D.y - C.y);

        if (!this.isCorss(A, B, C, D))
            return null;

        // 二つの線分の交点を算出する。
        // http://mf-atelier.sakura.ne.jp/mf-atelier/modules/tips/program/algorithm/a1.html
        let d1, d2;

        d1 = (C.y * D.x) - (C.x * D.y);
        d2 = (A.y * B.x) - (A.x * B.y);

        out.x = (d1 * (B.x - A.x) - d2 * (D.x - C.x)) / bunbo;
        out.y = (d1 * (B.y - A.y) - d2 * (D.y - C.y)) / bunbo;

        return out;
    }
    getCrossPoint (lines, line_port, port) {
        for (let line of lines) {
            let point = this.getCrossPointCore(line, line_port, port);

            if (point)
                return point;
        }
        return null;
    }
    getEntityLines () {
        let port_r = 4;
        let margin =  this.margin + port_r;

        let w = this.size.w;
        let h = this.size.h;

        let top_left     = { x:0 - margin, y:0 - margin};
        let top_right    = { x:w + margin, y:0 - margin};
        let bottom_rigth = { x:w + margin, y:h + margin};
        let bottom_left  = { x:0 - margin, y:h + margin};

        return [
            { from: top_left,     to: top_right    },
            { from: top_right,    to: bottom_rigth },
            { from: bottom_rigth, to: bottom_left  },
            { from: bottom_left,  to: top_left     },
        ];
    }
    positioningPort (port) {
        let line_port = this.makePortLine(port);
        let lines_entity = this.getEntityLines();

        let point = this.getCrossPoint(lines_entity, line_port, port);
        if (!point)
            point = {x:0, y:0};

        port.position = point;

        return port;
    }
    positioningPorts () {
        for (let entity of this._data)
            for (let port of this.ports.items.list)
                this.positioningPort(entity, port);
    }
    positioning () {
        this.positioningName();
        this.positioningType();
        this.positioningIdentifiers();
        this.positioningAttributes();
        this.positioningPorts();
    }
    /* **************************************************************** *
     *  Draw ※これはインスタンスメソッドより、クラスメソッド的な。
     * **************************************************************** */
    drawGroup (place) {
        let data = this._data;

        return place
            .selectAll('g.entity')
            .data(data, (d) => { return d._id; })
            .enter()
            .append('g')
            .attr('class', 'entity')
            .attr('entity-id',   (d) => { return d._id; })
            .attr('entity-code', (d) => { return d._core.code; })
            .attr('entity-type', (d) => { return d._class; })
            .attr("transform", (d) => {
                return "translate(" + d.position.x + "," + d.position.y + ")";
            });
    }
    addMoveEvents2Body (body) {
        let self = this;

        return body.call(
            d3.drag()
                .on("start", (d) => { return self.dragStart(d); })
                .on("drag",  (d) => { return self.dragged(d); })
                .on("end",   (d) => { return self.dragEnd(d); }));
    }
    drawBodyCore (body) {
        body
            .attr('class', 'entity-body')
            .attr('width', (d) => { return d.size.w;})
            .attr('height', (d) => { return d.size.h;})
            .attr('fill', (d) => {
                return d.background.color;
            });
    }
    drawBody (groups) {
        let body = groups
            .append('rect');

        this.drawBodyCore(body);

        return this.addMoveEvents2Body(body);
    }
    // name
    drawNameRect (rects) {
        rects
            .attr('x', (d) => {
                return d.name.position.x;
            })
            .attr('y', (d) => {
                return d.name.position.y;
            })
            .attr('width', (d) => {
                return d.name.size.w;
            })
            .attr('height', (d) => {
                return d.name.size.h;
            })
            .attr('fill', (d) => { return '#ffffff'; });

    }
    drawNameText (texts) {
        return texts
            .attr('class', 'entity-title')
            .attr("x", (d) => {
                return d.padding + d.name.padding;
            })
            .attr("y", (d) => {
                return d.padding + d.name.padding + this._default.line.font.size;
            })
            .text((d) => {
                return d.name.contents;
            });
    }
    drawName (groups) {
        let self = this;

        let rects = groups
            .append('rect')
            .on("click", (d) => {
                let func = self._callbacks.entity.click;

                if (func) func(d);
            })
            .attr('class', 'entity-title');

        this.drawNameRect(rects);

        let texts = groups
            .append('text')
            .on("click", (d) => {
                let func = self._callbacks.entity.click;

                if (func) func(d);
            })
            .attr('class', 'entity-title');

        this.drawNameText(texts)
            .each(function (d) {
                if (!d._max)
                    d._max_w = {
                        name:       0,
                        identifier: 0,
                        attribute:  0,
                    };

                let w = this.getBBox().width;

                if (w > d._max_w.name)
                    d._max_w.name = w;
            });
    }
    // type
    drawTypeRect (selection) {
        selection
            .attr('x', (d) => {
                return d.type.position.x;
            })
            .attr('y', (d) => {
                return d.type.position.y;
            })
            .attr('width', (d) => {
                return d.type.size.w;
            })
            .attr('height', (d) => {
                return d.type.size.h;
            })
            .attr('fill', (d) => { return '#ffffff'; });
    }
    drawTypeText (selection) {
        selection
            .attr("x", (d) => {
                return d.padding +
                    d.name.size.w +
                    11 +
                    d.type.padding;
            })
            .attr("y", (d) => {
                return d.type.position.y + d.type.padding + this._default.line.font.size;
            })
            .text((d) => {
                return d.type.contents;
            });
    }
    drawType (groups) {
        let rects = groups
            .append('rect')
            .attr('class', 'entity-type');

        this.drawTypeRect(rects);

        let texts = groups
            .append('text')
            .attr('class', 'entity-type');

        this.drawTypeText(texts);
    }
    // identifier
    drawIdentifiersRect (rects) {
        rects
            .attr('x', (d) => {
                return d.identifiers.position.x;
            })
            .attr('y', (d) => {
                return d.identifiers.position.y;
            })
            .attr('width', (d) => {
                return d.identifiers.size.w;
            })
            .attr('height', (d) => {
                return d.identifiers.size.h;
            })
            .attr('fill', (d) => { return '#ffffff'; });
    }
    drawIdentifiersText (texts) {
        return texts
            .attr("x", (d) => {
                return d.position.x;
            })
            .attr("y", (d) => {
                return d.position.y;
            })
            .text((d) => {
                return d.name;
            });
    }
    drawIdentifiers (groups) {
        let rects = groups
            .append('rect')
            .attr('class', 'entity-identifiers');

        this.drawIdentifiersRect(rects);

        let texts = groups
            .selectAll('text.identifier')
            .data((d) => {
                return d.identifiers.items.list;
            })
            .enter()
            .append('text')
            .attr('class', 'identifier')
            .attr('identifier-id', (d) => { return d._id; });

        this.drawIdentifiersText(texts)
            .each(function (identifier) {
                let w = this.getBBox().width;

                if (w > identifier._entity._max_w.identifier)
                    identifier._entity._max_w.identifier = w;
            });
    }
    // Attribute
    drawAttributesRect (rects) {
        rects
            .attr('x', (d) => {
                return d.attributes.position.x;
            })
            .attr('y', (d) => {
                return d.attributes.position.y;
            })
            .attr('width', (d) => {
                return d.attributes.size.w;
            })
            .attr('height', (d) => {
                return d.attributes.size.h;
            })
            .attr('fill', (d) => { return '#ffffff'; });
    }
    drawAttributesText (texts) {
        return texts
            .attr("x", (d) => {
                return d.position.x;
            })
            .attr("y", (d) => {
                return d.position.y;
            })
            .text((d) => {
                return d.name;
            });
    }
    drawAttributes (groups) {
        let rects = groups
            .append('rect')
            .attr('class', 'entity-attributes');

        this.drawAttributesRect(rects);

        let texts = groups
            .selectAll('text.attribute')
            .data((d) => {
                return d.attributes.items.list;
            })
            .enter()
            .append('text')
            .attr('class', 'attribute')
            .attr('attribute-id', (d) => { return d._id; });

        this.drawAttributesText(texts)
            .each(function (attribute) {
                let w = this.getBBox().width;

                if (w > attribute._entity._max_w.attribute)
                    attribute._entity._max_w.attribute = w;
            });
    }
    // ports
    drawPortsCore (ports) {
        ports
            .attr('class', 'entity-port')
            .attr('cx', (d) => {
                return d.position.x;
            })
            .attr('cy', (d) => {
                return d.position.y;
            })
            .attr('r', 4)
            .attr('fill', '#fff')
            .attr('stroke', '#000')
            .attr('stroke-width', 0.5)
            .attr('degree', (d) => {
                return d._core.position;
            })
            .attr('port-id', (d) => {
                return d._core._id;
            });
    }
    drawPorts (groups) {
        let ports = groups
            .selectAll('circle.entity-port')
            .data((d) => {
                return d.ports.items.list;
            })
            .enter()
            .append('circle');

        this.drawPortsCore(ports);
    }
    // main
    draw (place, callbacks) {
        this._callbacks = callbacks;

        let groups = this.drawGroup(place);

        this.drawBody(groups);
        this.drawName(groups);
        this.drawType(groups);
        this.drawIdentifiers(groups);
        this.drawAttributes(groups);

        this.reSizing(groups);

        this.drawPorts(groups);
    }
    /* **************************************************************** *
     *  Drag & Drop
     * **************************************************************** */
    moveEdges (edges) {
        // TODO:
    }
    moveEntity(entity) {
        let selection = this._place
            .selectAll('g.entity')
            .data([entity], (d) => { return d._id; });

        selection
            .attr('transform', (d)=>{
                return 'translate(' + d.position.x + ',' + d.position.y + ')';
            });

        // this.moveEdges([...]);
    }
    dragStart (entity) {
        let e = d3.event;

        entity._drag = {
            start: {
                x: e.x,
                y: e.y,
            }
        };
    }
    dragged (entity) {
        let e = d3.event;

        entity.position.x += e.x - entity._drag.start.x;
        entity.position.y += e.y - entity._drag.start.y;

        this.moveEntity(entity);
    }
    dragEnd (entity) {
        let state = STORE.state().get('schemas');
        let code = state.active;
        let schema = state.list.find((d) => { return d.code == code; });

        delete entity._drag;

        ACTIONS.saveTerEntityPosition(schema, entity);
    }
    /* **************************************************************** *
     *  Actions
     * **************************************************************** */
    reDraw (groups) {
        this.drawBodyCore(groups.selectAll('rect.entity-body'));
        this.drawNameRect(groups.selectAll('rect.entity-title'));
        this.drawNameText(groups.selectAll('text.entity-title'));
        this.drawTypeRect(groups.selectAll('rect.entity-type'));
        this.drawTypeText(groups.selectAll('text.entity-type'));
        this.drawIdentifiersRect(groups.selectAll('rect.entity-identifiers'));
        this.drawIdentifiersText(groups.selectAll('text.identifier'));
        this.drawAttributesRect(groups.selectAll('rect.entity-attributes'));
        this.drawAttributesText(groups.selectAll('text.attribute'));
    }
    movePort (entity_core, port_core) {
        let entity = this._data.find((d) => {
            return d._id == entity_core._id;
        });
        let port = entity.ports.items.ht[port_core._id];

        this.positioningPort(entity, port);

        // redraw ports
        let ports = this._place
            .selectAll('circle.entity-port')
            .data([port], (d) => { return d._id; });

        this.drawPortsCore(ports);


        // redraw edge
        let edges     = [];
        let add_edges = (ht) => {
            for (let k in ht) {
                let edge = ht[k];
                if (edge.from_class=="PORT-TER" && edge.to_class=="PORT-TER")
                    edges.push(edge);
            }
        };
        add_edges(this._edges.indexes.from[port._id]);
        add_edges(this._edges.indexes.to[port._id]);

        let elements = this._background
            .selectAll('line.connector')
            .data(edges, (d) => { return d._id; });

        this.drawEdgesCore(elements);
    }
}
