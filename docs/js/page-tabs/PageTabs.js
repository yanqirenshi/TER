class PageTabs {
    constructor (tabs) {
        this.active_tab = null;
        this.tabs = tabs;
    }
    switchTab (tags, code) {
        if (!code) code = this.tabs[0].code;

        if (this.active_tab == code) return false;

        let next_active_tab = null;
        for (var i in this.tabs) {
            let tab = this.tabs[i];
            tags[tab.tag].root.classList.add('hide');

            if (tab.code==code)
                next_active_tab = tab;
        }

        tags[next_active_tab.tag].root.classList.remove('hide');

        this.active_tab = code;

        return true;
    };

}
