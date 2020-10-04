# ER


## Object Model

```
    +--------+                   +-----------------+              +---------+
    | column |---:instance-of--->| column-instance |----:have---->| port-er |<--+
    +--------+     edge-ter      |                 |   edge-ter   +---------+   |
                                 |                 |                   |        |
    +-------+                    |                 |                  :fk       |
    | table |-------:have------->|                 |                edge-ter    |
    +-------+      edge-ter      +-----------------+                   |        |
                                                                       +--------+


    +-------------+      +-----------------+      +-------------+
    |column       |      | column-instance |      | table       |
    |=============|      |=================|      |=============|
    | %id         |      | %id             |      | %id         |
    | code        |      | code            |      | code        |
    | name        |      | name            |      | name        |
    | description |      | description     |      | description |
    | data-type   |      | physical-name   |      | data-type   |
    |-------------|      | logical-name    |      | x           |
    +-------------+      | data-type       |      | y           |
                         | column-type     |      | z           |
                         |-----------------|      | w           |
                         +-----------------+      | h           |
                                                  | columns     |
                                                  |-------------|
                                                  +-------------+



                                                  +-------------+
                                                  | port-er     |
                                                  |=============|
                                                  | %id         |
                                                  | code        |
                                                  | name        |
                                                  | description |
                                                  | degree      |
                                                  +-------------+
                                                     |
                                                     |
                                                     |    +------------+
                                                     +--->| port-er-in |
                                                     |    |============|
                                                     |    |------------|
                                                     |    +------------+
                                                     |
                                                     |    +-------------+
                                                     `--->| port-er-out |
                                                          |=============|
                                                          |-------------|
                                                          +-------------+
```
