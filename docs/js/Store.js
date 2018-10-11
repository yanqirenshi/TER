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
                code: "page01",
                menu_label: 'ペ1',
                active_section: 'root',
                home_section: 'root',
                sections: [
                    { code: 'root', tag: 'page01_page_root', name: 'root' },
                    { code: 'sec1', tag: 'page01_page1',     name: 'page1' },
                    { code: 'sec2', tag: 'page01_page2',     name: 'page2' },
                    { code: 'sec3', tag: 'page01_page3',     name: 'page3' },
                ],
                stye: {
                    color: { 1: '#fdeff2', 2: '#e0e0e0', 3: '#e198b4', 4: '#ffffff', 5: '#eeeeee', 5: '#333333' }
                }
            },
            {
                code: "page02", menu_label: 'ペ2',
                active_section: 'root', home_section: 'root',
                sections: [{ code: 'root', tag: 'page02_page_root' }],
                stye: {
                    color: { 1: '#fdeff2', 2: '#e0e0e0', 3: '#e198b4', 4: '#ffffff', 5: '#eeeeee', 5: '#333333' }
                }
            },
            {
                code: "page03", menu_label: 'ペ3',
                active_section: 'root', home_section: 'root',
                sections: [{ code: 'root', tag: 'page03_page_root', title: 'Home', description: '' }],
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
