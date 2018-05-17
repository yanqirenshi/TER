# Ter

```text
                   [attribute] - name
                       |       - data type
                      1:n
                       |
                       V
[entity]--1:n-->[entity-attribute]
```

```text
resource -- resouce
resource -- event
event    -- event
```

```text
TH: resource -- resouce

[entity-rs]--1:1-->[entity-th]<--1:1--[entity-rs]

[entity-attribute]--Seq:1--[entity-th]--Seq:1--[entity-attribute]
[entity-attribute]--Seq:2--[entity-th]--Seq:2--[entity-attribute]
[entity-attribute]--Seq:3--[entity-th]--Seq:3--[entity-attribute]
```

```text
TH: resource -- event

[entity-attribute]---[entity-attribute]
```

```text
TO: event -- event

[entity-ev]--1:1-->[entity-to]<--1:1--[entity-ev]

[entity-attribute]--Seq:1--[entity-to]--Seq:1--[entity-attribute]
[entity-attribute]--Seq:2--[entity-to]--Seq:2--[entity-attribute]
[entity-attribute]--Seq:3--[entity-to]--Seq:3--[entity-attribute]
```


## Usage

## Installation
