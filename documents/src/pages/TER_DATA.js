const TER_DATA = {
    identifiers: [
        { id: 10, name: { physical: 'resource_id', logical: 'リソースID' } },
        { id: 11, name: { physical: 'event_id',    logical: 'イベントID' } },
    ],
    attributes: [
        { id: 20, name: { physical: 'aaa', logical: 'bbb' } },
        { id: 21, name: { physical: 'ccc', logical: 'ddd' } },
    ],
    entities: [
        {
            id: 1,
            type: 'RESOURCE',
            name: { physical: 'aaa', logical: 'bbb' },
            position: { x: 10, y: -100 },
            size: { w: 100, h: 200},
            identifiers: [
                { id: 1000, name: { physical: '111', logical: '222' }, identifier: 10, position: 270 },
            ],
            attributes: [
                { id: 2000, name: { physical: 'aaa', logical: 'bbb' }, attribute: 20 },
                { id: 2001, name: { physical: 'ccc', logical: 'ddd' }, attribute: 21 },
            ],
        },
        {
            id: 2,
            type: 'EVENT',
            name: { physical: 'ccc', logical: 'ddd' },
            position: { x: 500, y: -100 },
            size: { w: 100, h: 200},
            identifiers: [
                { id: 1100, name: { physical: '555', logical: '666' }, identifier: 11 },
                { id: 1101, name: { physical: '777', logical: '888' }, identifier: 10, position: 90 },
            ],
            attributes: [
                { id: 2100, name: { physical: 'eee', logical: 'fff' }, attribute: 20 },
                { id: 2101, name: { physical: 'ggg', logical: 'hhh' }, attribute: 21 },
            ],
        },
    ],
    relationships: [
        { from: 1000, to: 1101 },
    ],
};

export default TER_DATA;
