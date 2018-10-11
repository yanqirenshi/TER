<core_page_tab_classes>
    <section class="section">
        <div class="container">
            <h1 class="title is-4">List</h1>
            <h2 class="subtitle"></h2>

            <section class="section">
                <div class="container">
                    <h1 class="title is-5">TER</h1>
                    <h2 class="subtitle"></h2>
                    <div class="contents">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr each={getClasses('ter')}>
                                    <td>{name.toUpperCase()}</td>
                                    <td>{description}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>

            <section class="section">
                <div class="container">
                    <h1 class="title is-5">TER</h1>
                    <h2 class="subtitle"></h2>
                    <div class="contents">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Description</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr each={getClasses('er')}>
                                    <td>{name.toUpperCase()}</td>
                                    <td>{description}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </section>

    <script>
     this.getClasses = (group) => {
         return this.classes.filter((d) => {
             return d.group == group;
         });
     };
     this.classes = [
         { group: 'common', package: '', name: 'rsc',                 parent: ''                    },
         { group: 'common', package: '', name: 'rect',                parent: ''                    },
         { group: 'common', package: '', name: 'port',                parent: ''                    },
         { group: 'common', package: '', name: 'point',               parent: ''                    },

         { group: 'ter',    package: '', name: 'resource',            parent: 'shin rsc point rect' },
         { group: 'ter',    package: '', name: 'event',               parent: 'shin rsc point rect' },
         { group: 'ter',    package: '', name: 'comparative',         parent: 'shin rsc point rect' },
         { group: 'ter',    package: '', name: 'correspondence',      parent: 'shin rsc point rect' },
         { group: 'ter',    package: '', name: 'recursion',           parent: 'shin rsc point rect' },
         { group: 'ter',    package: '', name: 'identifier',          parent: 'shin'                },
         { group: 'ter',    package: '', name: 'identifier-instance', parent: 'shin'                },
         { group: 'ter',    package: '', name: 'attribute',           parent: 'shin'                },
         { group: 'ter',    package: '', name: 'attribute-instance',  parent: 'shin'                },
         { group: 'ter',    package: '', name: 'port-ter',            parent: 'shin rsc point'      },
         { group: 'ter',    package: '', name: 'edge-ter',            parent: 'ra'                  },
         { group: 'ter',    package: '', name: 'campus',              parent: 'shin rsc'            },

         { group: 'er',     package: '', name: 'table',               parent: 'shin rsc point rect' },
         { group: 'er',     package: '', name: 'column',              parent: 'shin rsc'            },
         { group: 'er',     package: '', name: 'column-instance',     parent: 'shin rsc'            },
         { group: 'er',     package: '', name: 'port-er',             parent: 'shin rsc port'       },
         { group: 'er',     package: '', name: 'port-er-in',          parent: 'port-er'             },
         { group: 'er',     package: '', name: 'port-er-out',         parent: 'port-er'             },
         { group: 'er',     package: '', name: 'edge-er',             parent: 'ra'                  },

         { group: 'mapper', package: '', name: 'edge-map',            parent: 'ra'                  },
         { group: 'base',   package: '', name: 'camera',              parent: 'shin rsc'            },
         { group: 'base',   package: '', name: 'edge',                parent: 'ra'                  },
         { group: 'base',   package: '', name: 'schema',              parent: 'shin rsc'            },
     ];
    </script>
</core_page_tab_classes>
