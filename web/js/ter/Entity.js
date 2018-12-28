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
            location: { x:0, y:0, z:0 },
            size: { w:0, h:0 },
            padding: 11,
            margin: 6,
            background: {
                color: '',
            },

            name: {
                location: { x:0, y:0, z:0 },
                size: { h: null, w: null },
                padding: 11,
                contents: ''
            },

            type: {
                location: { x:0, y:0, z:0 },
                size: { h: null, w: 42 },
                padding: 11,
                size: { w:0, h:0 },
            },

            identifiers: {
                location: { x:0, y:0, z:0 },
                padding: 11,
                size: { w: null, h: null },
                items: { list: [], ht: {} },
            },

            attributes: {
                location: { x:0, y:0, z:0 },
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
        obj.location = { x:0, y:0 };
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

        new_entity.name.contents = entity.naem;
        new_entity.description.contents = entity.description;
        new_entity.location = { x:entity.x, y:entity.y, z:entity.z };
        new_entity.size = { w:entity.w, h:entity.h };
        new_entity.type.contents = this.entityTypeContents(entity);

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
        d.location.x = entity.padding;
        d.location.y = entity.padding;
    }
    positioningType (entity) {
        let d = entity.type;
        let margin = 11;
        d.location.x = entity.padding + entity.name.size.w + margin;
        d.location.y = entity.padding;
    }
    positioningColumnItems (d) {
        let len = d.items.list.length;
        let padding = (4 * 2);
        let start = (d.location.y + d.padding + 6);
        let item_h = (this._default.line.height + padding);

        for (let i=0 ; i<len ; i++) {
            let item = d.items.list[i];
            item.location.x = d.location.x + d.padding;
            item.location.y = start + i * item_h;
        }
    }
    positioningIdentifiers (entity) {
        let d = entity.identifiers;
        let margin = 11;

        d.location.x = entity.padding;
        d.location.y = entity.padding + entity.name.size.h + margin;

        this.positioningColumnItems (d);
    }
    positioningAttributes (entity) {
        let d = entity.attributes;
        let margin1 = (4 * 2);
        let margin2 = 11;

        d.location.x = entity.padding + margin1 + entity.identifiers.size.w;
        d.location.y = entity.padding + entity.name.size.h + margin2;

        this.positioningColumnItems (d);
    }
    deg2rad (degree) {
        if (degree>=90)
            degree = degree % 90;

        return degree * ( Math.PI / 180 );
    }
    makePortLine (entity, port) {
        let out = {
            from: {x:0, y:0},
            to: {x:0, y:0},
        };

        // center を from とする。
        out.from.x = Math.floor(entity.size.w / 2);
        out.from.y = Math.floor(entity.size.h / 2);

        // ピタゴラスの定理で最大の線の長さを取得する。
        let max_length = Math.floor(Math.sqrt((entity.size.w * entity.size.w) + (entity.size.h * entity.size.h)));
        let port_line_length = 2 * max_length;

        let degree = port.position;

        if (degree>=360)
            degree = degree % 360;

        let radian = this.deg2rad(degree);
        let ret_acos = Math.acos(radian==0 ? 1 : radian);

        // https://math.nakaken88.com/textbook/basic-trigonometric-functions-0-180/
        if (ret_acos==0)
            out.to.x = 0;
        else
            out.to.x = Math.floor(ret_acos * port_line_length);

        if (180 <= degree && degree < 360)
            out.to.x *= -1;

        let ret_asin = Math.asin(radian);
        if (ret_asin==0)
            out.to.y = port_line_length;
        else
            out.to.y = Math.floor(ret_asin * port_line_length);
        if ( 90 <=  degree && degree < 270)
            out.to.y *= -1;

        out.to.x += out.from.x;
        out.to.y += out.from.y;

        return out;
    }
    getCrossPointCore (line, line_port) {
        // ２直線の交点を求める公式
        let out = { x:0, y:0 };

        let A = line.from;
        let B = line.to;
        let C = line_port.from;
        let D = line_port.to;

        let bunbo = (B.y - A.y) * (D.x - C.x) - (B.x - A.x) * (D.y - C.y);

        if ( bunbo==0 )
            return null;

        // 交差しているかをチェックする。
        // https://www.hiramine.com/programming/graphics/2d_segmentintersection.html
        let AC = { x: C.x - A.x, y: C.y - A.y };
        let r = ( (D.y - C.y) * AC.x - (D.x - C.x) * AC.y ) / bunbo;
        let s = ( (B.y - A.y) * AC.x - (B.x - A.x) * AC.y ) / bunbo;
        if (!((0<=r && r<=1) || (0<=s && s<=1)))
            return null;

        // こうてんを算出する。
        // http://mf-atelier.sakura.ne.jp/mf-atelier/modules/tips/program/algorithm/a1.html
        let d1, d2;

        d1 = (C.y * D.x) - (C.x * D.y);
        d2 = (A.y * B.x) - (A.x * B.y);

        out.x = (d1 * (B.x - A.x) - d2 * (D.x - C.x)) / bunbo;
        out.y = (d1 * (B.y - A.y) - d2 * (D.y - C.y)) / bunbo;

        return out;
    }
    getCrossPoint (lines, line_port) {
        for (let line of lines) {
            let point = this.getCrossPointCore(line, line_port);
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

        return this.getCrossPoint(lines_entity, line_port);
    }
    positioningPorts (entity) {
        for (let entity of this._data)
            for (let port of entity.ports.items.list) {
                let point = this.positioningPort(entity, port);

                if (!point) {
                    point = {x:0, y:0};
                    //throw Error('???!');
                }
                port.location = point;
            }
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
                return "translate(" + d.location.x + "," + d.location.y + ")";
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
                return d.name.location.x;
            })
            .attr('y', (d) => {
                return d.name.location.y;
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
                return d.type.location.x;
            })
            .attr('y', (d) => {
                return d.type.location.y;
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
                return d.type.location.y + d.type.padding + this._default.line.font.size;
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
                return d.identifiers.location.x;
            })
            .attr('y', (d) => {
                return d.identifiers.location.y;
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
                return d.location.x;
            })
            .attr("y", (d) => {
                return d.location.y;
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
                return d.attributes.location.x;
            })
            .attr('y', (d) => {
                return d.attributes.location.y;
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
                return d.location.x;
            })
            .attr("y", (d) => {
                return d.location.y;
            })
            .text((d) => {
                return d.name;
            });
    }
    drawPorts (groups) {
        // TODO: いったんおてあげほりゅう
        // groups.selectAll('circle.entity-port')
        //     .data((d) => {
        //         console.log(d.ports.items.list);
        //         return d.ports.items.list;
        //     })
        //     .enter()
        //     .append('circle')
        //     .attr('class', 'entity-port')
        //     .attr('cx', (d) => {
        //         return d.location.x;
        //     })
        //     .attr('cy', (d) => {
        //         return d.location.y;
        //     })
        //     .attr('r', 4)
        //     .attr('fill', '#fff')
        //     .attr('stroke', '#000')
        //     .attr('stroke-width', 0.5);
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
