class Router {
    constructor(store, actions) {
        this._store = store;
        this._actions = actions;

        let self = this;
        route(function (a) {
            self.routing(arguments);
        });
    }
    routing (args) {
        let store = this._store;
        let actions = this._actions;

        let site = store.state().get('site');

        let len = args.length;
        let page_code = args[0] ? args[0] : site.home_page;

        site.active_page = page_code;

        let page = site.pages.find((d) => { return d.code == page_code; });

        page.active_section = args.length==2 ? args[1] : page.home_section;

        store.dispatch(actions.movePage({
            site: site
        }));
    }
    start () {
        route.start(function () {
            let hash = location.hash;
            let len = hash.length;
            if (len==0)
                return '/';
            return hash.substring(1);
        }());
    }
    /* **************************************************************** *
     * page
     * **************************************************************** */
    findPageTags (tags) {
        let page_tags = {};
        for (var k in tags) {
            let tag = tags[k];
            let cls = tag.opts.class;
            if (cls && cls.split(' ').find((c)=>{ return c=='page';}))
                page_tags[k] = tag;
        }
        return page_tags;
    }
    switchPage (root_tag, page_holder_elem, site) {
        let tags = root_tag.tags;
        let trg_show = [];

        for (var i in site.pages) {
            let page = site.pages[i];
            let key = page.code;
            let tag = tags[key];


            if (site.active_page==key) {
                if (!tag) {
                    trg_show.push(key);
                }
                if (tag && !tag.isMounted) {
                    trg_show.push(key);
                }
                if (tag && tag.isMounted) {
                    tag.update();
                }
            } else {
                if (tag && tag.isMounted)
                    tag.unmount();
            }
        }

        for (var i in trg_show) {
            let tag_name = trg_show[i];

            var elem = document.createElement(tag_name);

            elem.classList.add('page');

            page_holder_elem.appendChild(elem);

            let new_page_tag = riot.mount(tag_name);
            root_tag.tags[tag_name] = new_page_tag[0];
        }
    }
    /* **************************************************************** *
     * section
     * **************************************************************** */
    mountSections (page, active_section_code, sections) {
        let root = page.root;

        for (var i in sections) {
            let section = sections[i];
            let tag_name = 'func-' + section.code;

            var elem = document.createElement(tag_name);

            if (section.code==active_section_code)
                elem.classList.add('page-section');
            else
                elem.classList.add('page-section', 'hide');

            root.appendChild(elem);

            let opts = {};
            if (section.code=='root')
                opts.sections = sections;

            let new_tags = riot.mount(tag_name, opts);

            page.tags[tag_name] = new_tags[0];
        }
    }
    switchSection (root_tag, active_section_code, sections_data) {
        let tags = root_tag.tags;
        let trg_show = [];

        for (var i in sections_data) {
            let section = sections_data[i];
            let section_code = section.code;
            let tag = tags[section.tag];

            if (active_section_code==section_code) {
                if (!tag) {
                    trg_show.push(section_code);
                }
                if (tag && !tag.isMounted) {
                    trg_show.push(section_code);
                }
                if (tag && tag.isMounted) {
                    tag.update();
                }
            } else {
                if (tag && tag.isMounted)
                    tag.unmount();
            }
        }

        for (var i in trg_show) {
            let tag_code = trg_show[i];
            let section_data = sections_data.find((d) => { return d.code==tag_code; });
            let tag_name = section_data.tag;

            var elem = document.createElement(tag_name);

            elem.classList.add('page-section');

            root_tag.root.appendChild(elem);

            let new_page_tag = riot.mount(tag_name, { page_code: root_tag.pageCode() });
            root_tag.tags[tag_name] = new_page_tag[0];
        }
    };
    /* **************************************************************** *
     * util
     * **************************************************************** */
    isHaveClass (class_trg, class_string) {
        if (!class_string) return false;

        let classes = class_string.trim().split(' ');
        let results = classes.find((cls) => { return cls==class_trg; });

        return !(results.length==0);
    };
    rmClass (class_trg, class_string) {
        let classes = class_string.trim().split(' ');
        let results = classes.filter((cls) => { return cls!=class_trg; });

        return results.join(' ');
    };
    addClass (class_trg, class_string) {
        let classes = class_string.trim().split(' ');
        if (classes.filter((cls) => { return cls==class_trg; }).length==0)
            classes.push(class_trg);

        return classes.join(' ');
    };
}
