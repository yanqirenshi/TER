class Store extends Vanilla_Redux_Store {
    constructor(reducer) {
        super(reducer, Immutable.Map({}));
    }
    siteBase () {
        return {
            menu_label: '管理',
            code: "managements",
            tag: 'page-base',
            children: [
                {
                    code: "systems",
                    children: [
                        {
                            code: "base",
                            tag: 'page-system',
                            regex: new RegExp('^\\d+$'),
                        }
                    ],
                }
            ],
        };
    }
    siteModelers () {
        return {
            menu_label: '造形師',
            code: "modelers",
            tag: 'page-modelers',
            children: [
                {
                    code: "systems",
                    children: [
                        {
                            code: "base",
                            tag: 'page-system',
                            regex: new RegExp('^\\d+$'),
                        }
                    ],
                }
            ],
        };
    }
    siteTER () {
        return {
            menu_label: 'T字形ER図',
            code: "ter",
            tag: 'page-ter',
        };
    }
    siteER () {
        return {
            menu_label: 'ER図',
            code: "er",
            tag: 'page-er',
        };
    }
    site () {
        return {
            active_page: 'ter',
            home_page: 'ter',
            pages: [
                this.siteTER(),
                this.siteER(),
                this.siteModelers(),
                this.siteBase(),
            ]
        };
    }
    initEr () {
        return {
            tables:           {ht: {}, list: []},
            columns:          {ht: {}, list: []},
            column_instances: {ht: {}, list: []},
            ports:            {ht: {}, list: []},
            relashonships:    {ht: {}, list: []},
            system:           null,
            schemas:          { ht: {}, list: [] },
            //
            schema:           null, // TODO: これは不要な気がするな。
            cameras:          { ht: {}, list: [] }, // TODO: これは不要な気がするな。
        };
    }
    initTer () {
        return {
            entities:             { ht: {}, list: [] },
            identifier_instances: { ht: {}, list: [] },
            attribute_instances:  { ht: {}, list: [] },
            relationships:        { ht: {}, list: [], indexes: { from: {}, to: {} } },
            ports:                { ht: {}, list: [] },
            system:               null,
            campuses:             { ht: {}, list: [] },
            //
            camera:               null, // TODO: これは不要な気がするな。
            cameras:              { ht: {}, list: [] }, // TODO: これは不要な気がするな。
            campus:               null, // TODO: これは不要な気がするな。
        };
    }
    initHomeGraph () {
        return {
            nodes: {ht: {}, list: []},
            edges: {ht: {}, list: []},
            cameras: []
        };
    }
    init () {
        let data = {
            site:      this.site(),
            // environments
            systems:   { ht: {}, list: [] },
            active: {
                system: null,
                ter: { campus: null },
                er:  { schema: null },
            },
            modeler: null,
            //
            er:        this.initEr(),
            ter:       this.initTer(),
            //
            graph:     this.initHomeGraph(),
            inspector: { display: false, data: null },
            global: {
                menu: {
                    move_panel: {
                        open: false
                    }
                }
            },
            modals: {
                'create-system': null,
                'create-entity': null,
            },
        };

        for (var i in data.site.pages) {
            let page = data.site.pages[i];
            for (var k in page.sections) {
                let section = page.sections[k];
                let hash = '#' + page.code;

                if (section.code!='root')
                    hash += '/' + section.code;

                section.hash = hash;
            }
        }


        this._contents = Immutable.Map(data);
        return this;
    }
}
