class Builder {
    template () {
        return {
            _id : null,
            _class: 'ENTITY',
            description: { contents: '' },
            position: { x:0, y:0, z:0 },
            size: { w:0, h:0 },
            padding: 11,
            margin: 6,
            bar: {
                size: {
                    header: 11,
                    contents: 8,
                }
            },
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
                contents: '??',
                position: { x:0, y:0, z:0 },
                size: { w:0, h:0 },
                padding: 11,
            },
            identifiers: {
                position: { x:0, y:0, z:0 },
                size: { w: null, h: null },
                padding: 8,
                items: { list: [], ht: {} },
            },
            attributes: {
                position: { x:0, y:0, z:0 },
                size: { w: null, h: null },
                padding: 8,
                items: { list: [], ht: {} },
            },
            ports: {
                items: { list: [], ht: {} },
            }
        };
    }
    entityTypeContents (core) {
        switch (core.type) {
        case 'RESOURCE':        return 'Rsc';
        case 'RESOURCE-SUBSET': return 'Rsc';
        case 'COMPARATIVE':     return '対象';
        case 'EVENT':           return 'Evt';
        case 'EVENT-SUBSET':    return 'Evt';
        default: throw new Error(core._class + " は知らないよ。");
        }
    }
    entityBackground (core) {
        const background = {
            "resource":        { color: '#89c3eb' },
            "resource-subset": { color: '#a0d8ef' },
            "event":           { color: '#f09199' },
            "event-subset":    { color: '#f6bfbc' },
            "comparative":     { color: '#c8d5bb' },
            "correspondence":  { color: '#f2f2b0' },
            "recursion":       { color: '#dbd0e6' },
        };

        return background[core.type.toLowerCase()];
    }
    buildIdentifiers (core, state, entity_element) {
        let out = { list: [], ht: {} };

        const masters = state.identifiers.ht;

        for (let identifier of core.identifiers) {
            const master = masters[identifier.identifier];

            const element = this.identifier_instance.build(identifier, master);

            element._entity = entity_element;

            out.list.push(element);
            out.ht[element._id] = element;
        }

        return {
            contents: out,
            position: { x:0, y:0 },
            size: { w:0, h:0 },
            background: { color: '#ffffff'},
            padding: 11,
        };
    }
    buildAttributes (core, state, entity_element) {
        let out = { list: [], ht: {} };

        const masters = state.attributes.ht;

        for (let attribute of core.attributes) {
            const master = masters[attribute.attribute];

            const element = this.attribute_instance.build(attribute, master);

            element._entity = entity_element;

            out.list.push(element);
            out.ht[element._id] = element;
        }

        return {
            contents: out,
            position: { x:0, y:0 },
            size: { w:0, h:0 },
            background: { color: '#ffffff'},
            padding: 11,
        };
    }
    build (core, state) {
        let element = this.template();

        element._id = core.id;

        element.name.contents        = core.name;
        element.description.contents = core.description;

        element.position      = {...core.position};
        element.size          = {...core.size};
        element.type.contents = this.entityTypeContents(core);

        element.identifiers = this.buildIdentifiers(core, state, element);
        element.attributes  = this.buildAttributes (core, state, element);

        element.background = this.entityBackground(core);

        element._core = core;
        core._element = element;

        return element;
    }
}

export default class EntityTailor extends Builder {
    /* **************************************************************** *
     *   Size
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
                       entity.bar.size.header -
                       type.size.w);
    }
    sizingIdentifiers (entity) {
        let data = entity.identifiers;
        let padding = entity.padding;

        data.size.w =
            ((entity.size.w - (padding * 2)) / 2) -
            (entity.bar.size.contents / 2);

        data.size.h = data.contents.list.length
            * (this._default.line.height + padding * 2);
    }
    sizingAttributes (entity) {
        let data = entity.attributes;
        let padding = entity.padding;

        data.size.w =
            ((entity.size.w - (entity.padding * 2)) / 2) -
            (entity.bar.size.contents / 2);

        data.size.h = data.contents.list.length * (this._default.line.height + padding * 2);
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
    sizing (entities) {
        this.sizingEntities(entities);

        return this;
    }
    reSizingEntity (entity) {
        entity.name.size.w
            = Math.ceil(entity._max_w.name)
            + entity.name.padding * 2;

        entity.identifiers.size.w
            = Math.ceil(entity._max_w.identifier)
            + entity.identifiers.padding * 2;

        entity.attributes.size.w
            = Math.ceil(entity._max_w.attribute)
            + entity.attributes.padding * 2;

        let name_area_w =
            entity.name.size.w +
            entity.bar.size.header +
            entity.type.size.w +
            (entity.padding * 2);

        let contents_area_w =
            entity.identifiers.size.w
            + entity.bar.size.contents
            + entity.attributes.size.w
            + (entity.padding * 2);

        entity.size.w = contents_area_w > name_area_w ? contents_area_w : name_area_w;

        // fix size for attr area
        if (entity._max_w.attribute===0 || contents_area_w < name_area_w) {
            entity.attributes.size.w =
                entity.size.w -
                entity.identifiers.size.w -
                entity.bar.size.contents -
                (entity.padding * 2);
        }

        // fix size for name area
        if (contents_area_w > name_area_w) {
            entity.name.size.w =
                entity.size.w -
                entity.bar.size.header -
                entity.type.size.w -
                (entity.padding * 2);
        }
    }
    reSizing (groups, entities) {
        groups
            .each((entity) => {
                this.reSizingEntity(entity);
                this.positioningEntity(entity, entities);
            });

        this.redraw(groups);
    }
    /* **************************************************************** *
     *   Position
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
        let len     = d.contents.list.length;
        let padding = d.padding;
        let start   = (d.position.y);
        let line_height = this._default.line.height;
        let item_h  = (line_height + padding * 2);
        let magic_num = 3; // y軸の微調整係数

        for (let i=0 ; i<len ; i++) {
            let item = d.contents.list[i];
            item.position.x = d.position.x + padding;
            item.position.y = start + padding + line_height + i * item_h + magic_num;
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

        if (BUNBO===0)
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
    positioningPorts (entity, entities) {
        for (let entity of entities.list)
            for (let port of entity.ports.items.list)
                this.positioningPort(entity, port);
    }
    positioningEntity (entity, entities) {
        this.positioningName(entity);
        this.positioningType(entity);
        this.positioningIdentifiers(entity);
        this.positioningAttributes(entity);
        this.positioningPorts(entity, entities);
    }
    positioning () {
        for (let entity of this._data)
            this.positioningEntity(entity);

        return this;
    }
}
