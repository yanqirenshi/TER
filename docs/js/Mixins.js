let MIXINS = {
    page: {
        pageCode () {
            return this.root.tagName.toLowerCase();
        },
        draw: function () {
            let pages = STORE.state().get('site').pages;
            let page_state = pages.find((d) => {
                return d.code==this.pageCode();
            });

            ROUTER.switchSection(this,
                                 page_state.active_section,
                                 page_state.sections);
        }
    }
};
