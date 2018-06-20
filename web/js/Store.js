class Store extends Vanilla_Redux_Store {
    constructor(reducer) {
        super(reducer, Immutable.Map({}));
    }
    init () {
        let data = {
            schemas: {
                active: null,
                list: []
            },
            site: {
                active_page: 'page01',
                home_page: 'page01',
                pages: [
                    {
                        code: "page01",
                        title: "GRAPH",
                        menu_label: 'All',
                        active_section: 'root',
                        home_section: 'root',
                        sections: [
                            { code: 'root', tag: 'page01-sec_root', title: 'Section: root', description: '' }
                        ],
                        stye: {
                            color: { 1: '#fdeff2', 2: '#e0e0e0', 3: '#e198b4', 4: '#ffffff', 5: '#eeeeee', 5: '#333333' }
                        }
                    },
                    {
                        code: "page02",
                        title: "TER",
                        menu_label: 'TER',
                        active_section: 'root',
                        home_section: 'root',
                        sections: [{ code: 'root', tag: 'page02-sec_root', title: 'Home', description: '' }],
                        stye: {
                            color: { 1: '#fdeff2', 2: '#e0e0e0', 3: '#e198b4', 4: '#ffffff', 5: '#eeeeee', 5: '#333333' }
                        }
                    },
                    {
                        code: "page03",
                        title: "ER",
                        menu_label: 'ER',
                        active_section: 'root',
                        home_section: 'root',
                        sections: [{ code: 'root', tag: 'page03-sec_root', title: 'Home', description: '' }],
                        stye: {
                            color: { 1: '#fdeff2', 2: '#e0e0e0', 3: '#e198b4', 4: '#ffffff', 5: '#eeeeee', 5: '#333333' }
                        }
                    }
                ]
            },
            er: {
                tables:           {ht: {}, list: []},
                columns:          {ht: {}, list: []},
                column_instances: {ht: {}, list: []},
                relashonships:    {ht: {}, list: []},
                cameras: []
            },
            ter: {
                nodes: {ht: {}, list: []},
                edges: {ht: {}, list: []},
                cameras: []
            },
            graph: {
                nodes: {ht: {}, list: []},
                edges: {ht: {}, list: []},
                cameras: []
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
