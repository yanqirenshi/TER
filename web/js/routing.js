route(function (a) {
    let len = arguments.length;
    let page = arguments[0];
    let hash = location.hash;
    let new_pages = STORE.state().get('pages');

    for (var k in new_pages)
        new_pages[k].active = (('#'+k)==hash);

    STORE.dispatch(ACTIONS.movePage({
        pages: new_pages
    }));
});
