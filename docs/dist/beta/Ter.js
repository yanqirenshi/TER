class TerDataManeger {
    mergeStateDataObject (source, target) {
        if (source._id!=target._id)
            throw new Error('not eq object');

        for (let key in source)
            target[key] = source[key];
    }
    mergeStateData (source, target) {
        let new_target = {
            ht: Object.assign({}, target.ht),
            list: target.list.slice(),
        };

        if (target.indexes) {
            new_target.indexes = {
                from: Object.assign({}, target.indexes.from),
                to:   Object.assign({}, target.indexes.to),
            };
        }


        let ht = new_target.ht;
        for (let obj of source)
            if (ht[obj._id]) {
                this.mergeStateDataObject(obj, ht[obj._id]);
            } else {
                ht[obj._id] = obj;
                new_target.list.push(obj);
            }

        return new_target;
    }
    /**
     * relationship の _from と _to に値をセットします。
     */
    fixEdgesData (state) {
        let out = [];
        let edges = state.relationships.list;
        let keys = {
            'RESOURCE':            'entities',
            'EVENT':               'entities',
            'COMPARATIVE':         'entities',
            'IDENTIFIER-INSTANCE': 'identifier_instances',
            'ATTRIBUTE-INSTANCE':  'attribute_instances',
            'PORT-TER':            'ports',

        };
        let getNode = (node_class, _id) => {
            let key = keys[node_class];

            if (!key)
                throw new Error('対応していない node_class です。 node_class=' + node_class);

            return state[key].ht[_id];
        };

        for (let edge of edges) {
            let from = getNode(edge.from_class, edge.from_id);
            let to   = getNode(edge.to_class,   edge.to_id);

            if (!from || !to)
                continue;

            edge._from = from;
            edge._to   = to;

            out.push(edge);
        }

        return out;
    }
    /**
     * Relationship の index を作成します。
     */
    injectEdgeData (edges, new_state) {
        for (let edge of edges) {
            let index_from = new_state.relationships.indexes.from;
            let index_to   = new_state.relationships.indexes.to;

            if (!index_from[edge.from_id]) index_from[edge.from_id] = {};
            if (!index_to[edge.to_id])     index_to[edge.to_id]     = {};

            index_from[edge.from_id][edge._id] = edge;
            index_to[edge.to_id][edge._id]     = edge;
        }
    }
    /**
     * API で取得した response で作成した state もどきを、正式な state に変換する。たぶん
     * これは responses2state がイケてる気がする。
     */
    state2state(new_state) {
        let edges_fixed = this.fixEdgesData(new_state);

        this.injectEdgeData(edges_fixed, new_state);
    }
    /**
     * Json でロードしたデータを state に変換する。
     */
    json2state(json) {
        let pool = { ht: {}, list: [] };
        let pool_relationships = Object.assign({}, pool, { indexes: { from: {}, to: {} } });
        let state = {
            camera:               json.cameras,
            entities:             this.mergeStateData(json.entities,             pool),
            relationships:        this.mergeStateData(json.relationships,        pool_relationships),
            ports:                this.mergeStateData(json.ports,                pool),
            identifier_instances: this.mergeStateData(json.identifier_instances, pool),
            attribute_instances:  this.mergeStateData(json.attribute_instances,  pool),
        };

        this.injectEdgeData(this.fixEdgesData(state), state);

        return state;
    }
};

class Ter {
    constructor() {

        this._default = {
            line: {
                height: 14,
                font: {
                    size: 14
                }
            },
            style: {
                entity: {
                    background: {
                        resource:       { color: '#2ca9e1' },
                        event:          { color: '#ec6d71' },
                        comparative:    { color: '#c8d5bb' },
                        correspondence: { color: '#f2f2b0' },
                        recursion:      { color: '#dbd0e6' },
                    }
                }
            }
        };
    }
    /* **************************************************************** *
     *  Data manegement
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
                position: { x:0, y:0, z:0 },
                size: { h: null, w: 42 },
                padding: 11,
                size: { w:0, h:0 },
            },

            identifiers: {
                position: { x:0, y:0, z:0 },
                padding: 8, // 各項目の一辺の padding 値
                size: { w: null, h: null },
                items: { list: [], ht: {} },
            },

            attributes: {
                position: { x:0, y:0, z:0 },
                padding: 8, // 各項目の一辺の padding 値
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
        case 'RESOURCE':    return 'Rsc';
        case 'COMPARATIVE': return '対象';
        case 'EVENT':       return 'Evt';
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
    addIdentifiers2Entity (entity, state) {
        let identifiers = state.identifier_instances.ht;
        let relationships = state.relationships.indexes.from[entity._id];

        let out = { list: [], ht: {} };

        for (let key in relationships) {
            let r = relationships[key];

            if (r.to_class=='IDENTIFIER-INSTANCE') {
                let core = identifiers[r.to_id];

                core._entity = entity;
                core._parent = entity.identifiers;
                this.addOut(this.makeColumnData(core), out);
            }
        }

        entity.identifiers.items = out;
    }
    addAttributes2Entity (entity, state) {
        let attributes = state.attribute_instances.ht;
        let relationships = state.relationships.indexes.from[entity._id];

        let out = { list: [], ht: {} };

        for (let key in relationships) {
            let r = relationships[key];

            if (r.to_class=='ATTRIBUTE-INSTANCE') {
                let core = attributes[r.to_id];

                core._entity = entity;
                core._parent = entity.attributes;
                this.addOut(this.makeColumnData(core), out);
            }
        }

        entity.attributes.items  = out;
    }
    findEntityPorts (entity, state) {
        let identifiers = entity.identifiers.items.list;
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
    addPorts2Entity (entity, state) {
        let identifiers = entity.identifiers.items.list;
        let edges_all = state.relationships.indexes.from;

        let ports = this.findEntityPorts(entity, state);

        for (let port_core of ports) {
            let items = entity.ports.items;
            let port = {
                position: { x:0, y:0 },
                _id: port_core._id,
                _class: port_core._class,
                _core: port_core,
                _entity: entity,
            };

            port_core._element = port;

            items.list.push(port);
            items.ht[port._id] = port;
        };
    }
    makeGraphEntity (entity, state) {
        let new_entity = this.makeGraphEntityTemplate();

        let toplevs = ['_id', '_class'];
        for (let colkey of toplevs)
            new_entity[colkey] = entity[colkey];

        new_entity.name.contents        = entity.name;
        new_entity.description.contents = entity.description;
        new_entity.position             = Object.assign({}, entity.position);
        new_entity.size                 = Object.assign({}, entity.size);
        new_entity.type.contents        = this.entityTypeContents(entity);

        this.addIdentifiers2Entity(new_entity, state);
        this.addAttributes2Entity(new_entity, state);
        this.addPorts2Entity(new_entity, state);

        let background_ht = this._default.style.entity.background;
        new_entity.background = background_ht[entity._class.toLowerCase()];
        new_entity._core = entity;

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

        this._edges = state.relationships;

        return this;
    }
    /* **************************************************************** *
     *  Sizing
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
        let split_bar_size = 11;

        data.size.w = (entity.size.w - (entity.padding * 2) -
                       entity.bar.size.header -
                       type.size.w);
    }
    sizingIdentifiers (entity) {
        let data = entity.identifiers;
        let padding = entity.padding;

        data.size.w =
            ((entity.size.w - (entity.padding * 2)) / 2) -
            (entity.bar.size.contents / 2);
        data.size.h = data.items.list.length * (this._default.line.height + padding * 2);
    }
    sizingAttributes (entity) {
        let data = entity.attributes;
        let padding = entity.padding;

        data.size.w =
            ((entity.size.w - (entity.padding * 2)) / 2) -
            (entity.bar.size.contents / 2);
        data.size.h = data.items.list.length * (this._default.line.height + padding * 2);
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
    reSizingEntity (entity) {
        entity.name.size.w        = Math.ceil(entity._max_w.name)       + entity.name.padding * 2;
        entity.identifiers.size.w = Math.ceil(entity._max_w.identifier) + entity.identifiers.padding * 2;
        entity.attributes.size.w  = Math.ceil(entity._max_w.attribute)  + entity.attributes.padding * 2;

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
        if (entity._max_w.attribute==0 || contents_area_w < name_area_w) {
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
    reSizing (groups) {
        groups
            .each((entity) => {
                this.reSizingEntity(entity);
                this.positioningEntity(entity);
            });

        this.reDrawEntity(groups);
    }
    /* **************************************************************** *
     *  Positioning
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
        let len     = d.items.list.length;
        let padding = d.padding;
        let start   = (d.position.y);
        let line_height = this._default.line.height;
        let item_h  = (line_height + padding * 2);
        let magic_num = 3; // y軸の微調整係数

        for (let i=0 ; i<len ; i++) {
            let item = d.items.list[i];
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
    positioningEntity (entity) {
        this.positioningName(entity);
        this.positioningType(entity);
        this.positioningIdentifiers(entity);
        this.positioningAttributes(entity);
        this.positioningPorts(entity);
    }
    positioning () {
        for (let entity of this._data)
            this.positioningEntity(entity);

        return this;
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
    dragStart (d) {
        let e = d3.event;

        d._drag = {
            start: {
                x: e.x,
                y: e.y,
            }
        };
    }
    dragged (d) {
        let e = d3.event;

        d.position.x += e.x - d._drag.start.x;
        d.position.y += e.y - d._drag.start.y;

        this.moveEntity(d);
    }
    dragEnd (entity) {
        let state = STORE.state().get('schemas');
        let code = state.active;
        let schema = state.list.find((d) => { return d.code == code; });

        delete entity._drag;

        ACTIONS.saveTerEntityPosition(schema, entity);
    }
    /* **************************************************************** *
     *  Draw
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
    // entity
    reDrawEntity (groups) {
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
    drawEntity (groups) {
        this.drawBody(groups);
        this.drawName(groups);
        this.drawType(groups);
        this.drawIdentifiers(groups);
        this.drawAttributes(groups);

        this.reSizing(groups);

        this.drawPorts(groups);
    }
    // edges
    drawEdgesCore (edges) {
        edges
            .attr('x1', (d) => {
                let port = d._from._element;
                let entity = port._entity;

                return port.position.x + entity.position.x;
            })
            .attr('y1', (d) => {
                let port = d._from._element;
                let entity = port._entity;

                return port.position.y + entity.position.y;
            })
            .attr('x2', (d) => {
                let port = d._to._element;
                let entity = port._entity;

                return port.position.x + entity.position.x;
            })
            .attr('y2', (d) => {
                let port = d._to._element;
                let entity = port._entity;

                return port.position.y + entity.position.y;
            })
            .attr('stroke', '#888888')
            .attr('stroke-width', 1);
    }
    drawEdges (place) {
        let data = this._edges.list.filter((edge) => {
            return edge.from_class=='PORT-TER' && edge.to_class=='PORT-TER';
        });

        let edges = place
            .selectAll('line.connector')
            .data(data, (d) => { return d._id; })
            .enter()
            .append('line')
            .attr('class', 'connector');

        this.drawEdgesCore(edges);
    }
    // main
    draw (forground, background, callbacks) {
        this._place = forground;
        this._background = background;
        this._callbacks = callbacks;

        this.drawEntity(this.drawGroup(forground));
        this.drawEdges(background);
    }
    /* **************************************************************** *
     *  move port
     * **************************************************************** */
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
