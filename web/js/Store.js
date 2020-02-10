class Store extends Vanilla_Redux_Store {
    constructor(reducer) {
        super(reducer, Immutable.Map({}));
    }
    childPageSystem () {
        return {
            code: "system",
            tag: 'page-system',
            regex: new RegExp('^\\d+$'),
        };
    }
    childPageModeler () {
        return {
            code: "modeler",
            tag: 'page-modeler',
            regex: new RegExp('^\\d+$'),
        };
    }
    siteManagements () {
        return {
            menu_label: '管理',
            code: "managements",
            tag: 'page-managements',
            children: [
                {
                    code: "systems",
                    children: [
                        this.childPageSystem(),
                    ],
                },
                {
                    code: "modelers",
                    children: [
                        this.childPageModeler(),
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
                    code: "modelers",
                    children: [
                        this.childPageModeler(),
                    ],
                }
            ],
        };
    }
    siteSystems () {
        return {
            menu_label: 'Systems',
            code: "systems",
            tag: 'page-systems',
            children: [
                this.childPageSystem(),
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
    siteAccount () {
        return {
            menu_label: 'Account',
            code: "account",
            tag: 'page-account',
        };
    }
    site () {
        return {
            active_page: 'ter',
            home_page: 'ter',
            pages: [
                this.siteTER(),
                this.siteER(),
                this.siteSystems(),
                this.siteModelers(),
                this.siteManagements(),
                this.siteAccount(),
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
    initModals () {
        return {
            'create-system': null,
            'choose-system': null,
            'create-entity': null,
            'create-relationship': null,
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
            modals: this.initModals(),
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
