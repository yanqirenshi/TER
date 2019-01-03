<core_page_tab_classes>
    <section class="section">
        <div class="container">
            <h1 class="title is-4">List</h1>
            <h2 class="subtitle"></h2>

            <core_page_tab_classes-table label="TER" data={getClasses('ter')}></core_page_tab_classes-table>
            <core_page_tab_classes-table label="ER" data={getClasses('er')}></core_page_tab_classes-table>
            <core_page_tab_classes-table label="Auth" data={getClasses('auth')}></core_page_tab_classes-table>
            <core_page_tab_classes-table label="Mapper" data={getClasses('mapper')}></core_page_tab_classes-table>
            <core_page_tab_classes-table label="Common" data={getClasses('common')}></core_page_tab_classes-table>
        </div>
    </section>

    <script>
     this.getClasses = (group) => {
         return this.classes.filter((d) => {
             return d.group == group;
         });
     };
     this.classes = [
         { name:'campus',               parent_classes:'shinra:shin rsc',            group:'ter',    package: 'TER', file:'./src/classes/ter/campus.lisp',          },
         { name:'entity',               parent_classes:'shinra:shin rsc',            group:'ter',    package: 'TER', file:'./src/classes/ter/entity.lisp',          },
         { name:'resource',             parent_classes:'entity',                     group:'ter',    package: 'TER', file:'./src/classes/ter/resource.lisp',        },
         { name:'event',                parent_classes:'entity',                     group:'ter',    package: 'TER', file:'./src/classes/ter/event.lisp',           },
         { name:'comparative',          parent_classes:'entity',                     group:'ter',    package: 'TER', file:'./src/classes/ter/comparative.lisp',     },
         { name:'correspondence',       parent_classes:'entity ',                    group:'ter',    package: 'TER', file:'./src/classes/ter/correspondence.lisp',  },
         { name:'recursion',            parent_classes:'entity',                     group:'ter',    package: 'TER', file:'./src/classes/ter/recursion.lisp',       },
         { name:'identifier',           parent_classes:'shinra:shin',                group:'ter',    package: 'TER', file:'./src/classes/ter/identifier.lisp',      },
         { name:'identifier-instance',  parent_classes:'shinra:shin rsc',            group:'ter',    package: 'TER', file:'./src/classes/ter/identifier.lisp',      },
         { name:'attribute',            parent_classes:'shinra:shin',                group:'ter',    package: 'TER', file:'./src/classes/ter/attribute.lisp',       },
         { name:'attribute-instance',   parent_classes:'shinra:shin rsc',            group:'ter',    package: 'TER', file:'./src/classes/ter/attribute.lisp',       },
         { name:'port-ter',             parent_classes:'shinra:shin rsc point',      group:'ter',    package: 'TER', file:'./src/classes/ter/port-ter.lisp',        },
         { name:'edge-ter',             parent_classes:'shinra:ra',                  group:'ter',    package: 'TER', file:'./src/classes/ter/edge-ter.lisp',        },

         { name:'schema',               parent_classes:'shinra:shin rsc',            group:'er',     package: 'TER', file:'./src/classes/base/schema.lisp',         },
         { name:'table',                parent_classes:'shinra:shin rsc point rect', group:'er',     package: 'TER', file:'./src/classes/er/table.lisp',            },
         { name:'column',               parent_classes:'shinra:shin rsc',            group:'er',     package: 'TER', file:'./src/classes/er/column.lisp',           },
         { name:'column-instance',      parent_classes:'shinra:shin rsc',            group:'er',     package: 'TER', file:'./src/classes/er/column.lisp',           },
         { name:'port-er',              parent_classes:'shinra:shin rsc port',       group:'er',     package: 'TER', file:'./src/classes/er/port-er.lisp',          },
         { name:'port-er-in',           parent_classes:'port-er',                    group:'er',     package: 'TER', file:'./src/classes/er/port-er.lisp',          },
         { name:'port-er-out',          parent_classes:'port-er',                    group:'er',     package: 'TER', file:'./src/classes/er/port-er.lisp',          },
         { name:'edge-er',              parent_classes:'shinra:ra',                  group:'er',     package: 'TER', file:'./src/classes/er/edge-er.lisp',          },
         { name:'camera',               parent_classes:'shinra:shin rsc',            group:'er',     package: 'TER', file:'./src/classes/base/camera.lisp',         },

         { name:'ghost-shadow',         parent_classes:'shinra:shin',                group:'auth',   package: 'TER', file:'./src/classes/modeler.lisp',             },
         { name:'modeler',              parent_classes:'shinra:shin',                group:'auth',   package: 'TER', file:'./src/classes/modeler.lisp',             },

         { name:'edge-map',             parent_classes:'shinra:ra',                  group:'mapper', package: 'TER', file:'./src/classes/mapper.lisp',              },

         { name:'point',                parent_classes:'',                           group:'common', package: 'TER', file:'./src/classes/common.lisp',              },
         { name:'rect',                 parent_classes:'',                           group:'common', package: 'TER', file:'./src/classes/common.lisp',              },
         { name:'rsc',                  parent_classes:'',                           group:'common', package: 'TER', file:'./src/classes/common.lisp',              },
         { name:'port',                 parent_classes:'',                           group:'common', package: 'TER', file:'./src/classes/common.lisp',              },
         { name:'edge',                 parent_classes:'shinra:ra',                  group:'common', package: 'TER', file:'./src/classes/edge.lisp',                },
         { name:'edge',                 parent_classes:'shinra:ra',                  group:'common', package: 'TER', file:'./src/base/common.lisp',                 },
     ];
    </script>
</core_page_tab_classes>
