import Pool from './Pool.js';

import IdentifierInstance from './IdentifierInstance.js';
import AttributeInstance  from './AttributeInstance.js';

export default class Entity {
    constructor() {
        this.attribute_instance = new AttributeInstance();
        this.identifier_instance = new IdentifierInstance ();
    }
    /* **************************************************************** *
     *
     * **************************************************************** */
    list2pool (list, f) {
        return new Pool().list2pool(list, f);
    }
    /* **************************************************************** *
     *
     * **************************************************************** */
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

        return out;
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

        return out;
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
    /* **************************************************************** *
     *
     * **************************************************************** */
    getIdentifier (id, entities) {
        for (const entity of entities.list)
            if (entity.identifiers.ht[id])
                return entity.identifiers.ht[id];

        return null;
    }
}
