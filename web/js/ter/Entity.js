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

            name: {
                size: { h: null, w: null },
                padding: 11,
                contents: ''
            },

            type: {
                size: { h: null, w: 42 },
                padding: 11,
                size: { w:0, h:0 },
            },

            identifiers: {
                padding: 11,
                size: { w: null, h: null },
                items: { list: [], ht: {} },
            },

            attributes: {
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
    addIdAndAttr2Entity (entity, state) {
        let identifiers = state.identifier_instances.ht;
        let attributes = state.attribute_instances.ht;
        let relationships = state.relationships.list;


        let out_id = { list: [], ht: {} };
        let out_attr = { list: [], ht: {} };
        let addOut = (obj, out) => {
            out.list.push(obj);
            out.ht[obj._id] = obj;
        };

        for (let r of relationships)
            if (this.isEntityClass(r.from_class))
                if (r.to_class=='IDENTIFIER-INSTANCE')
                    addOut(identifiers[r.to_id], out_id);
                else if (r.to_class=='ATTRIBUTE-INSTANCE')
                    addOut(attributes[r.to_id], out_attr);

        entity.identifiers.items = out_id;
        entity.attributes.items  = out_attr;
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

        this.addIdAndAttr2Entity(new_entity, state);
        console.log(new_entity);
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

        data.size.h = data.items.list.length * (this._default.line.height + 8);
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
    positioningAttributes () {
        for (let entity of this._data) {
            let data = entity.attributes;
        }
    }
    positioningPort (entity, port) {
        console.log([entity, port]);
    }
    positioningPorts () {
        for (let entity of this._data)
            for (let port of entity.ports.items.list)
                this.positioningPort(entity, port);
    }
    positioning () {
        this.positioningPorts();
        this.positioningAttributes();

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
            .attr('fill', (d) => { return '#f00000'; });
    }
    drawTitle (groups) {
        groups
            .append('rect')
            .attr('class', 'entity-title')
            .attr('x', (d) => {
                return d.padding;
            })
            .attr('y', (d) => {
                return d.padding;
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
                return d.padding +
                    d.name.size.w +
                    11;
            })
            .attr('y', (d) => {
                return d.padding;
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
                return d.padding + d.type.padding + this._default.line.font.size;
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
                return d.padding;
            })
            .attr('y', (d) => {
                return d.padding + d.name.size.h + 11;
            })
            .attr('width', (d) => {
                return d.identifiers.size.w;
            })
            .attr('height', (d) => {
                return d.identifiers.size.h;
            })
            .attr('fill', (d) => { return '#ffffff'; });
    }
    drawAttributes (groups) {
        groups
            .append('rect')
            .attr('class', 'entity-attributes')
            .attr('x', (d) => {
                return d.padding + (4 * 2) + d.identifiers.size.w;
            })
            .attr('y', (d) => {
                return d.padding + d.name.size.h + 11;
            })
            .attr('width', (d) => {
                return d.attributes.size.w;
            })
            .attr('height', (d) => {
                return d.attributes.size.h;
            })
            .attr('fill', (d) => { return '#ffffff'; });
    }
    drawPorts () {
    }
    draw (place) {
        let groups = this.drawGroup(place);

        this.drawBody(groups);
        this.drawTitle(groups);
        this.drawType(groups);
        this.drawIdentifiers(groups);
        this.drawAttributes(groups);
    }
}
