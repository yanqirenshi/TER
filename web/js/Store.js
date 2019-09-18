class Store extends Vanilla_Redux_Store {
    constructor(reducer) {
        super(reducer, Immutable.Map({}));
    }
    siteBase () {
        return {
            menu_label: '基',
            code: "base",
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
    siteTER () {
        return {
            menu_label: 'TER',
            code: "ter",
            tag: 'page-ter',
        };
    }
    siteER () {
        return {
            menu_label: 'ER',
            code: "er",
            tag: 'page-er',
        };
    }
    site () {
        return {
            active_page: 'base',
            home_page: 'base',
            pages: [
                this.siteBase(),
                this.siteTER(),
                this.siteER(),
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
            cameras:          { ht: {}, list: [] }, // TODO: これは不要な気がするな。
            system:           null,
            schema:           null, // TODO: これは不要な気がするな。
            schemas:          { ht: {}, list: [] },
        };
    }
    initTer () {
        return {
            camera:               null, // TODO: これは不要な気がするな。
            cameras:              { ht: {}, list: [] }, // TODO: これは不要な気がするな。
            entities:             { ht: {}, list: [] },
            identifier_instances: { ht: {}, list: [] },
            attribute_instances:  { ht: {}, list: [] },
            relationships:        { ht: {}, list: [], indexes: { from: {}, to: {} } },
            ports:                { ht: {}, list: [] },
            system:               null,
            campus:               null, // TODO: これは不要な気がするな。
            campuses:             { ht: {}, list: [] },
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
            schemas:   { active: null, list: [] },
            site:      this.site(),
            er:        this.initEr(),
            ter:       this.initTer(),
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
            }
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
