import moment from 'moment';

import Asshole            from '@yanqirenshi/assh0le';
import Entity             from './Entity.js';
import Identifier         from './Identifier.js';
import IdentifierInstance from './IdentifierInstance.js';
import Attribute          from './Attribute.js';
import AttributeInstance  from './AttributeInstance.js';
import Relationship       from './Relationship.js';
import Port               from './Port.js';

export default class AssholeD3TER extends Asshole {
    constructor() {
        super();

        this.entity = new Entity();
        this.relationship = new Relationship();

        this.attribute = new Attribute();
        this.attribute_instance = new AttributeInstance();

        this.identifier = new Identifier();
        this.identifier_instance = new IdentifierInstance ();

        this.port = new Port();

        this._entities      = this.entity.list2pool([]);
        this._relationships = this.relationship.list2pool([]);
        this._identifier    = this.identifier.list2pool([]);
        this._attribute     = this.attribute.list2pool([]);

        this._default = {
            line: {
                height: 14,
                font: {
                    size: 14
                }
            },
        };
    }
    /* **************************************************************** *
     *  Data manegement
     * **************************************************************** */
    isEntityClass (_class) {
        let classes = [
            'RESOURCE',
            'RESOURCE-SUBSET',
            'EVENT',
            'EVENT-SUBSET',
        ];

        return classes.indexOf(_class) > -1;
    }
    buildRelationshipsWithPort (relationships, entities) {
        let out = { list: [], ht: {} };

        for (const core of relationships) {
            const identifier_from = this.entity.getIdentifier(core.from.id, entities);
            const identifier_to   = this.entity.getIdentifier(core.to.id, entities);

            const port_from = this.port.build('from', core.from.position, identifier_from);
            const port_to   = this.port.build('to',   core.to.position,   identifier_to);

            let element = this.relationship.build(core, port_from, port_to);

            const entity_from = identifier_from._entity;
            const entity_to   = identifier_to._entity;

            port_from._entity = entity_from;
            port_to._entity = entity_to;

            entity_from.ports.items.ht[port_from._id] = port_from;
            entity_from.ports.items.list.push(port_from);

            entity_to.ports.items.ht[port_to._id] = port_to;
            entity_to.ports.items.list.push(port_to);

            out.list.push(element);
            out.ht[element._id] = element;
        }

        return out;
    }
    dataCore (data) {
        this._identifiers = this.identifier.list2pool(data.identifiers, (d) => {
            return this.identifier.build(d);
        });

        this._attributes = this.identifier.list2pool(data.attributes, (d) => {
            return this.attribute.build(d);
        });

        // build entity
        const elements = {
            identifiers:   this._identifiers,
            attributes:    this._attributes,
        };
        this._entities = this.entity.list2pool(data.entities, (d) => {
            return this.entity.build(d, elements);
        });

        // いちおう応急
        this._relationships = this.buildRelationshipsWithPort(
            data.relationships, this._entities
        );

        this._edges = this._relationships;
    }
    data (data) {
        this.dataCore(data);

        this.entity.sizing(this._entities.list);

        this.draw();

        return this;
    }
    /* **************************************************************** *
     *  Drag & Drop
     * **************************************************************** */
    moveEdges (edges) {
        // TODO:
    }
    moveEntity(entity) {
        let selection = this.getLayerForeground()
            .selectAll('g.entity')
            .data([entity], (d) => { return d._id; });

        selection
            .attr('transform', (d)=>{
                return 'translate(' + d.position.x + ',' + d.position.y + ')';
            });

        // this.moveEdges([...]);
    }
    movePort (entity_core, port_core) {
        let entity = this._data.find((d) => {
            return d._id === entity_core._id;
        });
        let port = entity.ports.items.ht[port_core._id];

        this.positioningPort(entity, port);

        // redraw ports
        let ports = this.getLayerForeground()
            .selectAll('circle.entity-port')
            .data([port], (d) => { return d._id; });

        this.drawPortsCore(ports);


        // redraw edge
        let edges     = [];
        let add_edges = (ht) => {
            for (let k in ht) {
                let edge = ht[k];
                if (edge.from_class==="PORT-TER" && edge.to_class==="PORT-TER")
                    edges.push(edge);
            }
        };
        add_edges(this._relationships.indexes.from[port._id]);
        add_edges(this._relationships.indexes.to[port._id]);

        let elements = this.getLayerBackground()
            .selectAll('line.connector')
            .data(edges, (d) => { return d._id; });

        this.drawEdgesCore(elements);
    }
    /* **************************************************************** *
     *  Draw
     * **************************************************************** */
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
        let data = this._relationships.list.filter((edge) => {
            return edge.from_class==='PORT-TER' && edge.to_class==='PORT-TER';
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
    draw () {
        this._callbacks = {};

        const forground = this.getLayerForeground();

        this.entity.draw(forground, this._entities);

        this.drawEdges(this.getLayerBackground());
    }
    /* **************************************************************** *
     *  move port
     * **************************************************************** */
    /* **************************************************************** *
     *  to Json
     * **************************************************************** */
    stateTER2Json (state) {
        let out = {};

        out.cameras = state.cameras.list;
        out.entities = state.entities.list;

        let modifyColumns = (obj) => {
            let new_data = Object.assign({}, obj);

            delete new_data._entity;
            delete new_data._parent;

            return new_data;
        };

        out.identifier_instances = state.identifier_instances.list.map(modifyColumns);
        out.attribute_instances  = state.attribute_instances.list.map(modifyColumns);

        out.relationships = state.relationships.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            delete new_data._from;
            delete new_data._to;

            return new_data;
        });

        out.ports = state.ports.list.map((obj) => {
            let new_data = Object.assign({}, obj);

            delete new_data._element;

            return new_data;
        });

        return JSON.stringify(out, null, 3);
    }
    downloadJson (name, json) {
        var blob = new Blob([ json ], {type : 'application/json'});

        var a = document.createElement("a");
        a.href = URL.createObjectURL(blob);
        a.target = '_blank';
        a.download = name + '.' + moment().format('YYYYMMDDHHmmssZZ') + '.json';
        a.click();

    }
}
