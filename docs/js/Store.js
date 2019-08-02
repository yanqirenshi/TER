class Store extends Vanilla_Redux_Store {
    constructor(reducer) {
        super(reducer, Immutable.Map({}));
    }
    pages() {
        return [
            {
                code: "home", menu_label: '家',
                active_section: 'root', home_section: 'root',
                sections: [
                    { code: 'root', tag: 'home_page_root' },
                ],
                stye: {
                    color: { 1: '#fdeff2', 2: '#e0e0e0', 3: '#e198b4', 4: '#ffffff', 5: '#eeeeee', 5: '#333333' }
                }
            },
            {
                code: "usage", menu_label: '使',
                active_section: 'root',
                home_section: 'root',
                sections: [
                    { code: 'root', tag: 'page-usage_root', name: 'root' },
                ],
                stye: {
                    color: { 1: '#fdeff2', 2: '#e0e0e0', 3: '#e198b4', 4: '#ffffff', 5: '#eeeeee', 5: '#333333' }
                }
            },
            {
                code: "core", menu_label: '核',
                active_section: 'root',
                home_section: 'root',
                sections: [
                    { code: 'root', tag: 'core_page_root', name: 'root' },
                    { code: 'tx-make-relationship',       tag: 'generic-function_tx-make-relationship' },
                    { code: 'tx-add-identifier-2-entity', tag: 'function_tx-add-identifier-2-entity' },
                    { code: 'tx-add-attribute-2-entity',  tag: 'function_tx-add-attribute-2-entity' },
                ],
                stye: {
                    color: { 1: '#fdeff2', 2: '#e0e0e0', 3: '#e198b4', 4: '#ffffff', 5: '#eeeeee', 5: '#333333' }
                }
            },
            {
                code: "api", menu_label: 'Api',
                active_section: 'root', home_section: 'root',
                sections: [{ code: 'root', tag: 'api_page_root' }],
                stye: {
                    color: { 1: '#fdeff2', 2: '#e0e0e0', 3: '#e198b4', 4: '#ffffff', 5: '#eeeeee', 5: '#333333' }
                }
            },
            {
                code: "web", menu_label: 'Web',
                active_section: 'root', home_section: 'root',
                sections: [
                    { code: 'root', tag: 'web_page_root' },
                    { code: 'er',   tag: 'web_page_er'   },
                    { code: 'ter',  tag: 'web_page_ter'  },
                ],
                stye: {
                    color: { 1: '#fdeff2', 2: '#e0e0e0', 3: '#e198b4', 4: '#ffffff', 5: '#eeeeee', 5: '#333333' }
                }
            }
        ];
    }
    init () {
        let data = {
            site: {
                active_page: 'home',
                home_page: 'home',
                pages: this.pages(),
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
