class Entity {
    constructor() {
        this._default = {
            line: {
                height: 14,
                font: {
                    size: 14
                }
            }
        };
    }
    /* **************************************************************** *
       Data manegement
     * **************************************************************** */
    makeGraphEntityTemplate () {
        return {
            _id : null,
            _class: null,
            description: { contents: '' },
            position: { x:0, y:0, z:0 },
            size: { w:0, h:0 },
            padding: 11,
            margin: 6,
            background: {
                color: '',
            },

            name: {
                position: { x:0, y:0, z:0 },
                size: { h: null, w: null },
                padding: 11,
                contents: ''
            },

            type: {
                position: { x:0, y:0, z:0 },
                size: { h: null, w: 42 },
                padding: 11,
                size: { w:0, h:0 },
            },

            identifiers: {
                position: { x:0, y:0, z:0 },
                padding: 11,
                size: { w: null, h: null },
                items: { list: [], ht: {} },
            },

            attributes: {
                position: { x:0, y:0, z:0 },
                padding: 11,
                size: { w: null, h: null },
                items: { list: [], ht: {} },
            },

            ports: {
                items: { list: [], ht: {} },
            }
        };
    }
    entityTypeContents (entity) {
        switch (entity._class) {
        case 'RESOURCE':
            return 'Rsc';
        }
        throw new Error(entity._class + " は知らないよ。");
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
    addAttributes2Entity (entity, state) {
        let attributes = state.attribute_instances.ht;
        let relationships = state.relationships.list;

        let out = { list: [], ht: {} };

        for (let r of relationships)
            if (this.isEntityClass(r.from_class))
                if (r.to_class=='ATTRIBUTE-INSTANCE') {
                    let core = attributes[r.to_id];

                    this.addOut(this.makeColumnData(core), out);
                }

        entity.attributes.items  = out;
    }
    addIdentifiers2Entity (entity, state) {
        let identifiers = state.identifier_instances.ht;
        let relationships = state.relationships.list;

        let out = { list: [], ht: {} };

        for (let r of relationships)
            if (this.isEntityClass(r.from_class))
                if (r.to_class=='IDENTIFIER-INSTANCE') {
                    let core = identifiers[r.to_id];

                    this.addOut(this.makeColumnData(core), out);
                }

        entity.identifiers.items = out;
    }
    makeGraphEntity (entity, state) {
        let new_entity = this.makeGraphEntityTemplate();

        let toplevs = ['_id', '_class'];
        for (let colkey of toplevs)
            new_entity[colkey] = entity[colkey];

        new_entity.name.contents        = entity.naem;
        new_entity.description.contents = entity.description;
        new_entity.position             = Object.assign({}, entity.position);
        new_entity.size                 = Object.assign({}, entity.size);
        new_entity.type.contents        = this.entityTypeContents(entity);

        this.addIdentifiers2Entity(new_entity, state);
        this.addAttributes2Entity(new_entity, state);
        new_entity.ports.items = state.ports;

        let background_ht = {
            resource:       { color: '#a0d8ef' },
            event:          { color: '#fdeff2' },
            comparative:    { color: '#c3d825' },
            correspondence: { color: '#f2f2b0' },
            recursion:      { color: '#dbd0e6' },
        };

        new_entity.background = background_ht[entity._class.toLowerCase()];

        return new_entity;
    }
    makeGraphEntities (state) {
        let list = state.entities.list;

        return list.map((entity) => {
            return this.makeGraphEntity(entity, state);
        });

    }
    data(state) {
        this._data =  this.makeGraphEntities (state);

        return this;
    }
    /* **************************************************************** *
       Sizing
     * **************************************************************** */
    sizingType (entity) {
        let data = entity.type;

        if (!data.contents)
            data.contents = '??';

        data.size.h = this._default.line.height + data.padding * 2;
        data.size.w = data.contents.length * this._default.line.font.size + data.padding * 2;
    }
    sizingName (entity) {
        let data = entity.name;

        if (!data.contents)
            data.contents = '????????';

        data.size.h = this._default.line.height + data.padding * 2;

        let type = entity.type;

        data.size.w = (entity.size.w - (entity.padding * 2) -
                       11 - // TODO: margin
                       type.size.w);
    }
    sizingIdentifiers (entity) {
        let data = entity.identifiers;
        let padding = (4 * 2);

        data.size.h = data.items.list.length * (this._default.line.height + padding);
        data.size.w = ((entity.size.w - (entity.padding * 2)) / 2) - 4;
    }
    sizingAttributes (entity) {
        let data = entity.attributes;

        data.size.h = data.items.list.length * (this._default.line.height + 8);
        data.size.w = ((entity.size.w - (entity.padding * 2)) / 2) - 4;
    }
    sizingContentsArea (entity) {
        let id_h = entity.identifiers.size.h;
        let attr_h = entity.attributes.size.h;

        if (id_h > attr_h)
            entity.attributes.size.h = id_h;
        else
            entity.identifiers.size.h = attr_h;
    }
    sizingEntity (entity) {
        this.sizingType(entity);
        this.sizingName(entity);
        this.sizingIdentifiers(entity);
        this.sizingAttributes(entity);
        this.sizingContentsArea(entity);

        let padding = entity.padding * 2;
        let header = entity.name.size.h;
        let margin = 11;
        let contents = entity.attributes.size.h;

        entity.size.h = padding + header + margin + contents;
    }
    sizingEntities (entities) {
        for (let entity of entities)
            this.sizingEntity (entity);
    }
    sizing () {
        this.sizingEntities(this._data);
        return this;
    }
    /* **************************************************************** *
       Positioning
     * **************************************************************** */
    positioningName (entity) {
        let d = entity.name;
        d.position.x = entity.padding;
        d.position.y = entity.padding;
    }
    positioningType (entity) {
        let d = entity.type;
        let margin = 11;
        d.position.x = entity.padding + entity.name.size.w + margin;
        d.position.y = entity.padding;
    }
    positioningColumnItems (d) {
        let len = d.items.list.length;
        let padding = (4 * 2);
        let start = (d.position.y + d.padding + 6);
        let item_h = (this._default.line.height + padding);

        for (let i=0 ; i<len ; i++) {
            let item = d.items.list[i];
            item.position.x = d.position.x + d.padding;
            item.position.y = start + i * item_h;
        }
    }
    positioningIdentifiers (entity) {
        let d = entity.identifiers;
        let margin = 11;

        d.position.x = entity.padding;
        d.position.y = entity.padding + entity.name.size.h + margin;

        this.positioningColumnItems (d);
    }
    positioningAttributes (entity) {
        let d = entity.attributes;
        let margin1 = (4 * 2);
        let margin2 = 11;

        d.position.x = entity.padding + margin1 + entity.identifiers.size.w;
        d.position.y = entity.padding + entity.name.size.h + margin2;

        this.positioningColumnItems (d);
    }
    deg2rad (degree) {
        return degree * ( Math.PI / 180 );
    }
    getPortLineLength (entity) {
        let max_length = Math.floor(Math.sqrt((entity.size.w * entity.size.w) + (entity.size.h * entity.size.h)));

        return 0.8 * max_length;
    }
    getPortLineFrom (entity) {
        return {
            x: Math.floor(entity.size.w / 2),
            y: Math.floor(entity.size.h / 2)
        };
    }
    makePortLine (entity, port) {
        let out = {
            from: {x:0, y:0},
            to:   {x:0, y:0},
        };

        let from = this.getPortLineFrom(entity);
        out.from.x = from.x;
        out.from.y = from.y;

        let x = 0;
        let y = this.getPortLineLength(entity);

        // let degree = 360 - (port.position % 360);
        let degree = port.position % 360;

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
    getEntityLines (entity) {
        let port_r = 4;
        let margin =  entity.margin + port_r;

        let w = entity.size.w;
        let h = entity.size.h;

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
    positioningPort (entity, port) {
        let line_port = this.makePortLine(entity, port);
        let lines_entity = this.getEntityLines(entity);

        let point = this.getCrossPoint(lines_entity, line_port, port);
        if (!point)
            point = {x:0, y:0};

        port.position = point;

        return port;
    }
    positioningPorts (entity) {
        for (let entity of this._data)
            for (let port of entity.ports.items.list)
                this.positioningPort(entity, port);
    }
    positioning () {
        for (let entity of this._data) {
            this.positioningName(entity);
            this.positioningType(entity);
            this.positioningIdentifiers(entity);
            this.positioningAttributes(entity);
            this.positioningPorts(entity);
        }

        return this;
    }
    /* **************************************************************** *
       Draw
     * **************************************************************** */
    drawGroup (place) {
        let data = this._data;

        return place
            .selectAll('g.entity')
            .data(data, (d) => { return d._id; })
            .enter()
            .append('g')
            .attr('class', 'entity')
            .attr("transform", (d) => {
                return "translate(" + d.position.x + "," + d.position.y + ")";
            });
    }
    drawBody (groups) {
        return groups
            .append('rect')
            .attr('class', 'entity-body')
            .attr('width', (d) => { return d.size.w;})
            .attr('height', (d) => { return d.size.h;})
            .attr('fill', (d) => {
                return d.background.color;
            });
    }
    drawName (groups) {
        groups
            .append('rect')
            .attr('class', 'entity-title')
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

        groups
            .append('text')
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
    drawType (groups) {
        groups
            .append('rect')
            .attr('class', 'entity-type')
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

        groups
            .append('text')
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
    drawIdentifiers (groups) {
        groups
            .append('rect')
            .attr('class', 'entity-identifiers')
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

        groups
            .selectAll('text.identifier')
            .data((d) => {
                return d.identifiers.items.list;
            })
            .enter()
            .append('text')
            .attr('class', 'identifier')
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
        groups
            .append('rect')
            .attr('class', 'entity-attributes')
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

        groups
            .selectAll('text.attribute')
            .data((d) => {
                return d.attributes.items.list;
            })
            .enter()
            .append('text')
            .attr('class', 'attribute')
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
    drawPorts (groups) {
        groups.selectAll('circle.entity-port')
            .data((d) => {
                return d.ports.items.list;
            })
            .enter()
            .append('circle')
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
            .attr('degree', (d) => { return d.position; });
    }
    draw (place) {
        let groups = this.drawGroup(place);

        this.drawBody(groups);
        this.drawName(groups);
        this.drawType(groups);
        this.drawIdentifiers(groups);
        this.drawAttributes(groups);
        this.drawPorts(groups);
    }
}
