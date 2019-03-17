# ter/

## State

```
{
    entities:             { list: [], ht: {} },
    identifier_instances: { list: [], ht: {} },
    attribute_instances:  { list: [], ht: {} },
    ports:                { list: [], ht: {} },
    relationships:        { list: [], ht: {} },
}
```

## Entity

```
{
    _id:      1,
    _class:   'RESOURCE',
    code:     'c1',
    name:     'n1',
    position: { x: 600, y:300, z:0 },
    size:     { w:333, h:222 },
}
```

## Identifier

```
{
   _id: _id++,
   _class: 'IDENTIFIER-INSTANCE'
   code: 'id1',
   name: 'id-1',
}
```

## Attribute

```
{
   _id:    _id++,
   _class: 'ATTRIBUTE-INSTANCE',
   code:   'attr1',
   name:   'attr-1',
}
```

## Port

```
```

## Relationship

```
{
   from_id:    from._id,
   from_class: from._class,
   to_id:      to._id,
   to_class:   to._class,
   _id:        _id++,
   _class:     'EDGE'
}
```
