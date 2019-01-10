riot.tag2('app', '<github-link href="https://github.com/yanqirenshi/TER" fill="#5BBBE7" color="#ffffff"></github-link> <menu-bar brand="{brand()}" site="{site()}" moves="{moves()}" data="{menuBarData()}" callback="{callback}"></menu-bar> <div ref="page-area"></div>', 'app > .page { width: 100vw; height: 100vh; overflow: hidden; display: block; } app .hide,[data-is="app"] .hide{ display: none; }', '', function(opts) {
     this.brand = () => {
         let brand = this.getActiveSchema();

         return { label: (brand ? brand.code : 'TER')};
     };

     this.callback = (type, e) => {
         if (type=='click-brand')
             return STORE.dispatch(ACTIONS.toggleMovePagePanel());

         if (type=='click-move-panel-item')
             return this.clickSchema(e);
     };

     this.clickSchema = (e) => {
         let schema_code = e.target.getAttribute('CODE');

         STORE.dispatch(ACTIONS.changeSchema(schema_code));

         ACTIONS.fetchErNodes(this.getActiveSchema());
     };

     this.moves = () => {
         let schemas = STORE.state().get('schemas').list;

         return schemas.map((d) => {
             return { code: d.code, href: '', label: d.code }
         });
     };

     this.site = () => {
         return STORE.state().get('site');
     };
     this.menuBarData = () => {
         return STORE.state().get('global').menu;
     };

     this.on('mount', function () {
         Metronome.start();
         ACTIONS.fetchEnvironment('FIRST');
     });

     this.getActiveSchema = () => {
         let state = STORE.state().get('schemas');
         let code = state.active;

         return state.list.find((d) => { return d.code == code; });
     };

     STORE.subscribe((action) => {
         if (action.type=='MOVE-PAGE') {
             let tags= this.tags;

             tags['menu-bar'].update();
             ROUTER.switchPage(this, this.refs['page-area'], this.site());
         }

         if (action.type=='FETCHED-ENVIRONMENT' && action.mode=='FIRST') {
             this.tags['menu-bar'].update();
             ACTIONS.fetchGraph('FIRST');
         }

         if (action.type=='FETCHED-GRAPH' && action.mode=='FIRST') {
             ACTIONS.fetchErNodes(this.getActiveSchema(), action.mode);
             ACTIONS.fetchTerEntities(action.mode);
         }

         if (action.type=='FETCHED-ER-NODES')
             ACTIONS.fetchErEdges(this.getActiveSchema(), action.mode);

         if (action.type=='FETCHED-ER-EDGES' && action.mode=='FIRST')
             ;

         if (action.type=='CHANGE-SCHEMA') {
             ACTIONS.saveConfigAtDefaultSchema(action.data.schemas.active);
             return;
         }

         if (action.type=='FETCHED-TER-ENTITIES')
             ACTIONS.fetchTerIdentifiers(action.mode);

         if (action.type=='FETCHED-TER-IDENTIFIERS')
             ACTIONS.fetchTerAttributes(action.mode);

         if (action.type=='FETCHED-TER-ATTRIBUTES')
             ACTIONS.fetchTerPorts(action.mode);

         if (action.type=='FETCHED-TER-PORTS')
             ACTIONS.fetchTerEdges(action.mode);

         if (action.type=='CLOSE-ALL-SUB-PANELS' || action.type=='TOGGLE-MOVE-PAGE-PANEL' )
             this.tags['menu-bar'].update();
     })

     window.addEventListener('resize', (event) => {
         this.update();
     });

     if (location.hash=='')
         location.hash='#page01'
});

riot.tag2('github-link', '<a id="fork" target="_blank" title="Fork Nobit@ on github" href="{opts.href}" class="github-corner"> <svg width="80" height="80" viewbox="0 0 250 250" fill="{opts.fill}" color="{opts.color}"> <path d="M0,0 L115,115 L130,115 L142,142 L250,250 L250,0 Z"></path> <path class="octo-arm" riot-d="{octo_arm.join(\',\')}" fill="currentColor" style="transform-origin: 130px 106px;"></path> <path class="octo-body" riot-d="{octo_body.join(\',\')}" fill="currentColor"></path> </svg> </a>', 'github-link > .github-corner > svg { position: fixed; top: 0; border: 0; right: 0; } github-link > .github-corner:hover .octo-arm { animation: octocat-wave 560ms ease-in-out } @keyframes octocat-wave { 0%, 100% { transform: rotate(0) } 20%, 60% { transform: rotate(-25deg) } 40%, 80% { transform: rotate(10deg) } }', '', function(opts) {
     this.octo_arm = ["M128.3",
                      "109.0 C113.8",
                      "99.7 119.0",
                      "89.6 119.0",
                      "89.6 C122.0",
                      "82.7 120.5",
                      "78.6 120.5",
                      "78.6 C119.2",
                      "72.0 123.4",
                      "76.3 123.4",
                      "76.3 C127.3",
                      "80.9 125.5",
                      "87.3 125.5",
                      "87.3 C122.9",
                      "97.6 130.6",
                      "101.9 134.4",
                      "103.2"];

     this.octo_body = ["M115.0",
                       "115.0 C114.9",
                       "115.1 118.7",
                       "116.5 119.8",
                       "115.4 L133.7",
                       "101.6 C136.9",
                       "99.2 139.9",
                       "98.4 142.2",
                       "98.6 C133.8",
                       "88.0 127.5",
                       "74.4 143.8",
                       "58.0 C148.5",
                       "53.4 154.0",
                       "51.2 159.7",
                       "51.0 C160.3",
                       "49.4 163.2",
                       "43.6 171.4",
                       "40.1 C171.4",
                       "40.1 176.1",
                       "42.5 178.8",
                       "56.2 C183.1",
                       "58.6 187.2",
                       "61.8 190.9",
                       "65.4 C194.5",
                       "69.0 197.7",
                       "73.2 200.1",
                       "77.6 C213.8",
                       "80.2 216.3",
                       "84.9 216.3",
                       "84.9 C212.7",
                       "93.1 206.9",
                       "96.0 205.4",
                       "96.6 C205.1",
                       "102.4 203.0",
                       "107.8 198.3",
                       "112.5 C181.9",
                       "128.9 168.3",
                       "122.5 157.7",
                       "114.1 C157.9",
                       "116.9 156.7",
                       "120.9 152.7",
                       "124.9 L141.0",
                       "136.5 C139.8",
                       "137.7 141.6",
                       "141.9 141.8",
                       "141.8 Z"];
});

riot.tag2('menu-bar', '<aside class="menu"> <p ref="brand" class="menu-label" onclick="{clickBrand}"> {opts.brand.label} </p> <ul class="menu-list"> <li each="{opts.site.pages}"> <a class="{opts.site.active_page==code ? \'is-active\' : \'\'}" href="{\'#\' + code}"> {menu_label} </a> </li> </ul> </aside> <div class="move-page-menu {movePanelHide()}" ref="move-panel"> <p each="{opts.moves}"> <a href="{href}" code="{code}" onclick="{clickMovePanelItem}">{label}</a> </p> </div>', 'menu-bar .move-page-menu { z-index: 666665; background: rgba(255,255,255,1); position: fixed; left: 55px; top: 0px; min-width: 111px; height: 100vh; box-shadow: 2px 0px 8px 0px #e0e0e0; padding: 22px 55px 22px 22px; } menu-bar .move-page-menu.hide { display: none; } menu-bar .move-page-menu > p { margin-bottom: 11px; } menu-bar > .menu { z-index: 666666; height: 100vh; width: 55px; padding: 11px 0px 11px 11px; position: fixed; left: 0px; top: 0px; background: rgba(44, 169, 225, 0.8); } menu-bar .menu-label, menu-bar .menu-list a { padding: 0; width: 33px; height: 33px; text-align: center; margin-top: 8px; border-radius: 3px; background: none; color: #ffffff; font-size: 12px; font-weight: bold; padding-top: 7px; } menu-bar .menu-label,[data-is="menu-bar"] .menu-label{ background: rgba(255,255,255,1); color: rgba(44, 169, 225, 0.8); } menu-bar .menu-label.open,[data-is="menu-bar"] .menu-label.open{ background: rgba(255,255,255,1); color: rgba(44, 169, 225, 0.8); width: 45px; border-radius: 3px 0px 0px 3px; text-shadow: 0px 0px 1px #eee; padding-right: 11px; } menu-bar .menu-list a.is-active { width: 45px; padding-right: 11px; border-radius: 3px 0px 0px 3px; background: #ffffff; color: #333333; }', '', function(opts) {
     this.brandStatus = (status) => {
         let brand = this.refs['brand'];
         let classes = brand.getAttribute('class').trim().split(' ');

         if (status=='open') {
             if (classes.find((d)=>{ return d!='open'; }))
                 classes.push('open')
         } else {
             if (classes.find((d)=>{ return d=='open'; }))
                 classes = classes.filter((d)=>{ return d!='open'; });
         }
         brand.setAttribute('class', classes.join(' '));
     }

     this.movePanelHide = () => {
         return this.opts.data.move_panel.open ? '' : 'hide'
     };

     this.clickBrand = (e) => {
         this.opts.callback('click-brand', e);
     };
     this.clickMovePanelItem = (e) => {
         this.opts.callback('click-move-panel-item', e);
     };

});

riot.tag2('operators', '<div> <a each="{opts.data}" class="button {color}" code="{code}" onclick="{click}"> {name} </a> </div>', 'operators > div { position: fixed; right: 11px; bottom: 11px; } operators .button { display: block; margin-top: 11px; }', '', function(opts) {
     this.click = (e) => {
         this.opts.callbak(e.target.getAttribute('code'));
     };
});

riot.tag2('page-tabs', '<div class="tabs is-boxed"> <ul> <li each="{opts.core.tabs}" class="{opts.core.active_tab==code ? \'is-active\' : \'\'}"> <a code="{code}" onclick="{clickTab}">{label}</a> </li> </ul> </div>', 'page-tabs li:first-child { margin-left: 11px; }', '', function(opts) {
     this.clickTab = (e) => {
         let code = e.target.getAttribute('code');
         this.opts.callback(e, 'CLICK-TAB', { code: code });
     };
});

riot.tag2('section-breadcrumb', '<section-container data="{path()}"> <nav class="breadcrumb" aria-label="breadcrumbs"> <ul> <li each="{opts.data}"> <a class="{active ? \'is-active\' : \'\'}" href="{href}" aria-current="page">{label}</a> </li> </ul> </nav> </section-container>', 'section-breadcrumb section-container > .section,[data-is="section-breadcrumb"] section-container > .section{ padding-top: 3px; }', '', function(opts) {
     this.path = () => {
         let hash = location.hash;
         let path = hash.split('/');

         if (path[0] && path[0].substr(0,1)=='#')
             path[0] = path[0].substr(1);

         let out = [];
         let len = path.length;
         let href = null;
         for (var i in path) {
             href = href ? href + '/' + path[i] : '#' + path[i];

             if (i==len-1)
                 out.push({
                     label: path[i],
                     href: hash,
                     active: true
                 });

             else
                 out.push({
                     label: path[i],
                     href: href,
                     active: false
                 });
         }
         return out;
     }
});

riot.tag2('section-container', '<section class="section"> <div class="container"> <h1 class="title is-{opts.no ? opts.no : 3}"> {opts.title} </h1> <h2 class="subtitle">{opts.subtitle}</h2> <yield></yield> </div> </section>', '', '', function(opts) {
});

riot.tag2('section-contents', '<section class="section"> <div class="container"> <h1 class="title is-{opts.no ? opts.no : 3}"> {opts.title} </h1> <h2 class="subtitle">{opts.subtitle}</h2> <div class="contents"> <yield></yield> </div> </div> </section>', 'section-contents > section.section { padding: 0.0rem 1.5rem 2.0rem 1.5rem; }', '', function(opts) {
});

riot.tag2('section-footer', '<footer class="footer"> <div class="container"> <div class="content has-text-centered"> <p> </p> </div> </div> </footer>', 'section-footer > .footer { padding-top: 13px; padding-bottom: 13px; height: 66px; background: #fef4f4; opacity: 0.7; }', '', function(opts) {
});

riot.tag2('section-header-with-breadcrumb', '<section-header title="{opts.title}"></section-header> <section-breadcrumb></section-breadcrumb>', 'section-header-with-breadcrumb section-header > .section,[data-is="section-header-with-breadcrumb"] section-header > .section{ margin-bottom: 3px; }', '', function(opts) {
});

riot.tag2('section-header', '<section class="section"> <div class="container"> <h1 class="title is-{opts.no ? opts.no : 3}"> {opts.title} </h1> <h2 class="subtitle">{opts.subtitle}</h2> <yield></yield> </div> </section>', 'section-header > .section { padding-top: 13px; padding-bottom: 13px; height: 66px; background: #fef4f4; margin-bottom: 33px; }', '', function(opts) {
});

riot.tag2('section-list', '<table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <th>機能</th> <th>概要</th> </tr> </thead> <tbody> <tr each="{data()}"> <td><a href="{hash}">{title}</a></td> <td>{description}</td> </tr> </tbody> </table>', '', '', function(opts) {
     this.data = () => {
         return opts.data.filter((d) => {
             if (d.code=='root') return false;

             let len = d.code.length;
             let suffix = d.code.substr(len-5);
             if (suffix=='_root' || suffix=='-root')
                 return false;

             return true;
         });
     };
});

riot.tag2('inspector-column-basic', '<section class="section"> <div class="container"> <h1 class="title is-5">物理名</h1> <div class="contents"> <p>{getVal(\'physical_name\')}</p> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title is-5">論理名</h1> <div class="contents"> <p>{getVal(\'logical_name\')}</p> <div style="text-align:right;"> <button class="button" onclick="{clickEditLogicalName}">論理名を変更</button> </div> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title is-5">Type</h1> <div class="contents"> <p>{getVal(\'data_type\')}</p> </div> </div> </section>', '', '', function(opts) {
     this.clickEditLogicalName = (e) => {
         if (this.opts.callback)
             this.opts.callback('click-edit-logical-name', this.opts.source);
     };
     this.getVal = (name) => {
         let data = this.opts.source;
         if (!data) return 'なし';

         return data[name];
     };
});

riot.tag2('inspector-column-description', '<div> <markdown-preview data="{marked(description())}"></markdown-preview> </div> <div style="margin-top:22px;"> <button class="button is-danger" onclick="{clickSaveDescription}">Edit</button> </div>', '', '', function(opts) {
     this.description = () => {
         if (!this.opts.source) return '';

         return this.opts.source.description;
     };

     this.clickSaveDescription = () => {
         let column_instance = this.opts.source;

         this.opts.callback('edit-column-instance-description', column_instance);
     };
});

riot.tag2('inspector-column', '<section class="section"> <div class="container"> <h1 class="title is-5">Column Instance</h1> <h2 class="subtitle" style="font-size: 0.8rem;"> <span>{opts.source ? opts.source.physical_name : \'\'}</span> : <span>{opts.source ? opts.source.logical_name : \'\'}</span> </h2> </div> </section> <page-tabs core="{page_tabs}" callback="{clickTab}"></page-tabs> <div style="margin-top:22px;"> <inspector-column-basic class="hide" source="{opts.source}" callback="{opts.callback}"></inspector-column-basic> <inspector-column-description class="hide" source="{opts.source}" callback="{opts.callback}"></inspector-column-description> </div>', 'inspector-column .section { padding: 11px; padding-top: 0px; } inspector-column section-contents .section { padding-bottom: 0px; padding-top: 0px; } inspector-column .contents, inspector-column .container { width: auto; }', '', function(opts) {
     this.page_tabs = new PageTabs([
         {code: 'basic',       label: 'Basic',       tag: 'inspector-column-basic' },
         {code: 'description', label: 'Description', tag: 'inspector-column-description' },
     ]);

     this.on('mount', () => {
         this.page_tabs.switchTab(this.tags)
         this.update();
     });

     this.clickTab = (e, action, data) => {
         if (this.page_tabs.switchTab(this.tags, data.code))
             this.update();
     };

     STORE.subscribe((action) => {
         if (action.type=='SAVED-COLUMN-INSTANCE-LOGICAL-NAME')
             this.update();
     });
});

riot.tag2('inspector-table-basic', '<section-container no="5" title="Name" name="{opts.name}"> <section-contents name="{opts.name}"> <p>{opts.name}</p> </section-contents> </section-container> <section-container no="5" title="Columns" columns="{opts.columns}"> <section-contents columns="{opts.columns}"> <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" style="font-size:12px;"> <thead> <tr> <th>物理名</th> <th>論理名</th> <th>タイプ</th></tr> </thead> <tbody> <tr each="{opts.columns}"> <td>{physical_name}</td> <td>{logical_name}</td> <td>{data_type}</td> </tr> </tbody> </table> </section-contents> </section-container>', '', '', function(opts) {
});

riot.tag2('inspector-table-description', '<div> <markdown-preview data="{marked(description())}"></markdown-preview> </div> <div style="margin-top:22px;"> <button class="button is-danger" onclick="{clickSave}">Edit</button> </div>', '', '', function(opts) {
     this.description = () => {
         if (!opts.data) return '';

         return opts.data.description;
     };

     this.clickSave = () => {
         let table = this.opts.data;

         this.opts.callback('edit-table-description', table);
     };
});

riot.tag2('inspector-table-relationship', '<div class="contents"> <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth"> <thead> <tr><th>Type</th><th>From</th><th>To</th></tr> </thead> <tbody> <tr each="{edges()}"> <td>{data_type}</td> <td>{_port_from._column_instance._table.name}</td> <td>{_port_to._column_instance._table.name}</td> </tr> </tbody> </table> </div>', '', '', function(opts) {
     this.edges = () => {
         if (this.opts && this.opts.data && this.opts.data._edges)
             return this.opts.data._edges

         return [];
     };
});

riot.tag2('inspector-table', '<div> <h1 class="title is-4" style="margin-bottom: 8px;">Table</h1> </div> <div style="margin-bottom:11px;"> <div class="tabs"> <ul> <li class="{isActive(\'basic\')}"> <a code="basic" onclick="{clickTab}">Basic</a> </li> <li class="{isActive(\'description\')}"> <a code="description" onclick="{clickTab}">Description</a> </li> <li class="{isActive(\'relationship\')}"> <a code="relationship" onclick="{clickTab}">Relationship</a> </li> </ul> </div> </div> <div style="flex-grow:1;"> <inspector-table-basic class="{isHide(\'basic\')}" name="{getVal(\'name\')}" columns="{getVal(\'_column_instances\')}"></inspector-table-basic> <inspector-table-description class="{isHide(\'description\')}" data="{data()}" callback="{this.opts.callback}"></inspector-table-description> <inspector-table-relationship class="{isHide(\'relationship\')}" data="{data()}"></inspector-table-relationship> </div>', 'inspector-table { height:100%; display:flex; flex-direction: column; } inspector-table .hide { display: none; } inspector-table .section { padding: 11px; padding-top: 0px; } inspector-table section-contents .section { padding-bottom: 0px; padding-top: 0px; } inspector-table .contents, inspector-table .container { width: auto; }', '', function(opts) {
     this.data = () => {
         return this.opts.data;
     };
     this.getVal = (name) => {
         let data = this.opts.data;

         if (!data || !data[name]) return '';

         if (name!='_column_instances')
             return data[name];
         else
             return data[name].sort((a,b)=>{ return (a._id*1) - (b._id*1); });
     };

     this.active_tab = 'basic'
     this.isActive = (code) => {
         return code == this.active_tab ? 'is-active' : '';
     };
     this.isHide = (code) => {
         return code != this.active_tab ? 'hide' : '';
     };
     this.clickTab = (e) => {
         this.active_tab = e.target.getAttribute('code');
         this.update();
     };
});

riot.tag2('inspector', '<div class="{hide()}"> <inspector-table class="{hideContents(\'table\')}" data="{data()}" callback="{opts.callback}"></inspector-table> <inspector-column class="{hideContents(\'column-instance\')}" source="{data()}" callback="{opts.callback}"></inspector-column> </div>', 'inspector > div { overflow-y: auto; min-width: 333px; max-width: 555px; height: 100vh; position: fixed; right: 0px; top: 0px; background: #fff; box-shadow: 0px 0px 8px #888; padding: 22px; } inspector > div.hide { display: none; } inspector .section > .container > .contents { padding-left:22px;}', '', function(opts) {
     this.state = () => { return STORE.state().get('inspector'); } ;
     this.data = () => {
         return this.state().data;
     };
     this.hideContents = (type) => {
         let data = this.data();
         if (!data) return 'hide';
         return data._class == type.toUpperCase() ? '' : 'hide';
     };
     this.hide = () => {
         return this.state().display ? '' : 'hide';
     };
     STORE.subscribe ((action) => {
         if (action.type=='SET-DATA-TO-INSPECTOR')
             this.update();

         if (action.type=='CLOSE-ALL-SUB-PANELS')
             this.update();
     })
});

riot.tag2('markdown-preview', '', 'markdown-preview h1 { font-weight: bold; font-size: 20px; margin-top: 11px; margin-bottom: 6px; } markdown-preview h2 { font-weight: bold; font-size: 18px; margin-top: 8px; margin-bottom: 4px; } markdown-preview h3 { font-weight: bold; font-size: 16px; margin-top: 6px; margin-bottom: 3px; } markdown-preview h4 { font-weight: bold; font-size: 14px; margin-top: 6px; margin-bottom: 3px; } markdown-preview h5 { font-weight: bold; font-size: 12px; margin-bottom: 4px; } markdown-preview * { font-size: 12px; } markdown-preview table { border-collapse: collapse; } markdown-preview td { border: solid 0.6px #888888; padding: 2px 5px; } markdown-preview th { border: solid 0.6px #888888; padding: 2px 5px; background: #eeeeee; }', '', function(opts) {
     this.on('update', () => {
         this.root.innerHTML = this.opts.data;
     });

    this.root.innerHTML = opts.data

});

riot.tag2('sections-list', '<table class="table"> <tbody> <tr each="{opts.data}"> <td><a href="{hash}">{title}</a></td> </tr> </tbody> </table>', '', '', function(opts) {
});

riot.tag2('er-modal-description', '<div class="modal {isActive()}"> <div class="modal-background"></div> <div class="modal-content" style="width: 88vw;"> <div class="card"> <div class="card-content" style="height: 88vh;"> <div style="display:flex; height: 100%; width: 100%;flex-direction: column;"> <div style="margin-bottom:11px;"> <h1 class="title is-4">{title()} の Description の変更</h1> </div> <div style="display:flex; flex-grow: 1"> <div style="flex-grow: 1;margin-right: 8px;"> <div class="element-container"> <h1 class="title is-5">Markdown</h1> <textarea class="input" ref="description" onkeyup="{inputDescription}">{description()}</textarea> </div> </div> <div style=";flex-grow: 1;margin-left: 8px;"> <div class="element-container"> <h1 class="title is-5">Preview</h1> <div class="preview" style="padding: 0px 11px 11px 11px;"> <markdown-preview data="{marked(markdown)}"></markdown-preview> </div> </div> </div> </div> <div style="margin-top:11px;"> <button class="button is-warning" onclick="{clickCancel}">Cancel</button> <button class="button is-danger" style="float:right;" onclick="{clickSave}">Save</button> </div> </div> </div> </div> </div> </div>', 'er-modal-description .element-container { display:flex; height: 100%; width: 100%; flex-direction: column; } er-modal-description .element-container .title{ margin-bottom:6px; } er-modal-description .input { border: 1px solid #eeeeee; padding: 11px; box-shadow: none; height: 100%; width: 100%; } er-modal-description .preview { border: 1px solid #eeeeee; flex-grow:1; }', '', function(opts) {
     this.markdown = null;

     this.clickCancel = () => {
         this.opts.callback('close-modal-description');
     };
     this.clickSave = () => {
         let source = this.opts.data;

         if (source._class=='COLUMN-INSTANCE') {
             this.opts.callback('save-column-instance-description', {
                 column_instance: this.opts.data,
                 value: this.refs['description'].value,
             });
         }

         if (source._class=='TABLE') {
             this.opts.callback('save-table-description', {
                 table: this.opts.data,
                 value: this.refs['description'].value,
             });
         }
     };
     this.inputDescription = () => {
         this.markdown = this.refs['description'].value;

         this.tags['markdown-preview'].update();
     };

     this.description = () => {
         if (!this.markdown) {
             let obj = this.opts.data;

             this.markdown = !obj ? '' : obj.description;
         }

         return this.markdown;
     };
     this.title = () => {
         if (!this.opts.data)
             return '';

         let obj = this.opts.data;
         return obj._class + ':' + obj.name;
     };
     this.isActive = () => {
         return this.opts.data ? 'is-active' : '';
     };
});

riot.tag2('er-modal-logical-name', '<div class="modal {isActive()}"> <div class="modal-background"></div> <div class="modal-content"> <nav class="panel"> <p class="panel-heading"> 論理名の変更 </p> <div class="panel-block" style="background: #fff;"> <span style="margin-right:11px;">テーブル: </span> <span>{tableName()}</span> </div> <div class="panel-block" style="background: #fff;"> <span style="margin-right:11px;">物理名:</span> <span>{physicalName()}</span> </div> <div class="panel-block" style="background: #fff;"> <input class="input" type="text" riot-value="{opts.data.logical_name}" placeholder="論理名" ref="logical_name"> </div> <div class="panel-block" style="background: #fff;"> <button class="button is-danger is-fullwidth" onclick="{clickSaveButton}"> Save </button> </div> </nav> </div> <button class="modal-close is-large" aria-label="close" onclick="{clickCloseButton}"></button> </div>', '', '', function(opts) {
     this.isActive = () => {
         return this.opts.data.data ? 'is-active' : '';
     };
     this.tableName = () => {
         if (!opts.data.data) return '???';

         let table = opts.data.data._table;

         return table.name;
     };
     this.physicalName = () => {
         if (opts.data.data)
             return opts.data.data.physical_name;

         return '???';
     };
     this.clickSaveButton = () => {
         this.opts.callback('click-save-button', {
             table_code: this.opts.data.data._table.code,
             column_instance_code: this.opts.data.data.code,
             logical_name: this.refs.logical_name.value
         });
     };
     this.clickCloseButton = () => {
         this.opts.callback('click-close-button');
     };
});

riot.tag2('er-sec_root', '<svg></svg> <operators data="{operators()}" callbak="{clickOperator}"></operators> <inspector callback="{inspectorCallback}"></inspector> <er-modal-logical-name data="{modalData()}" callback="{modalCallback}"></er-modal-logical-name> <er-modal-description data="{modal_target_table}" callback="{modalCallback}"></er-modal-description>', '', '', function(opts) {
     this.d3svg = null;
     this.ter = new Ter();
     this.modal_target_table = null;

     this.modalData = () => {
         let pages = STORE.state().get('site').pages;
         return pages.find((d) => { return d.code == 'er'; })
                     .modal
                     .logical_name;
     };

     this.state = () => {
         return STORE.state().get('er');
     };

     this.operators = () => {
         let state = STORE.state().get('site').pages.find((d) => { return d.code=='er'; });
         return state.operators;
     };
     this.clickOperator = (code) => {
         if (code=='move-center')
             return;

         if (code=='save-graph')
             ACTIONS.snapshotAll();
     };
     this.inspectorCallback = (type, data) => {
         let page_code = 'er';

         if (type=='click-edit-logical-name') {
             STORE.dispatch(ACTIONS.setDataToModalLogicalName(page_code, data));
             this.tags['er-modal-logical-name'].update();
             return;
         }

         if (type=='click-save-column-description')
             return ACTIONS.saveColumnInstanceDescription(data, page_code)

         if (type=='edit-table-description') {
             this.modal_target_table = data;

             this.update();
             return;
         }

         if (type=='edit-column-instance-description') {
             this.modal_target_table = data;

             this.update();
             return;
         }
     };
     this.modalCallback = (type, data) => {
         if (type=='click-close-button') {
             STORE.dispatch(ACTIONS.setDataToModalLogicalName('er', null));
             this.tags['er-modal-logical-name'].update();
             return;
         }
         if (type=='click-save-button') {
             data.schema_code = STORE.state().get('schemas').active;
             return ACTIONS.saveColumnInstanceLogicalName(data, 'er');
         }

         if (type=='close-modal-description') {
             this.modal_target_table = null;

             this.update();
             return;
         }

         if (type=='save-column-instance-description') {
             let schema_code = STORE.state().get('schemas').active;

             ACTIONS.saveColumnInstanceDescription(schema_code,
                                                   data.column_instance,
                                                   data.value,
                                                   'er');
             return;
         }

         if (type=='save-table-description') {
             let schema_code = STORE.state().get('schemas').active;

             ACTIONS.saveTableDescription(schema_code,
                                          data.table,
                                          data.value,
                                          'er');
             return;
         }
     };
     this.getD3Svg = () => {
         if (this.d3svg) return this.d3svg

         let camera = this.state().cameras[0];

         let callbacks = {
             moveEndSvg: (point) => {
                 let camera = this.state().cameras[0];
                 ACTIONS.saveCameraLookAt(camera, point);
             },
             zoomSvg: (scale) => {
                 let camera = this.state().cameras[0];
                 ACTIONS.saveCameraLookMagnification(camera, scale);
             },
             clickSvg: () => {
                 STORE.dispatch(ACTIONS.closeAllSubPanels());
             }
         };

         this.d3svg = this.ter.makeD3svg('er-sec_root > svg', camera, callbacks);

         return this.d3svg
     };

     STORE.subscribe((action) => {
         if (action.type=='FETCHED-ER-EDGES') {
             let d3svg = this.getD3Svg();

             this.ter.clear(d3svg);
             this.ter.drawTables(d3svg, STORE.state().get('er'));
         }

         if (action.type=='SAVED-COLUMN-INSTANCE-LOGICAL-NAME' && action.from=='er') {
             this.update();
             this.ter.reDrawTable (action.redraw);
         }

         if (action.type=='SAVED-TABLE-DESCRIPTION' && action.from=='er') {
             this.modal_target_table = null;
             this.update();
         }

         if (action.type=='SAVED-COLUMN-INSTANCE-DESCRIPTION' && action.from=='er') {
             this.modal_target_table = null;
             this.update();
         }
     });
});

riot.tag2('er', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('page01-sec_root', '<svg></svg>', '', '', function(opts) {
     this.d3svg = null;
     this.ter = new Ter();

     STORE.subscribe((action) => {
         if (action.type=='FETCHED-ENVIRONMENT' && action.mode=='FIRST')
             this.d3svg = this.ter.makeD3svg('page01-sec_root > svg');
     });
});

riot.tag2('page01', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('ter-sec_root', '<svg id="ter-sec_root-svg" ref="svg"></svg>', '', '', function(opts) {
     this.d3svg = null;
     this.svg   = null;

     this.ter = new Ter();

     this.draw = () => {
         let forground = this.svg.selectAll('g.base.forground');
         let background = this.svg.selectAll('g.base.background');
         let state     = STORE.get('ter');

         new Entity()
             .data(state)
             .sizing()
             .positioning()
             .draw(forground, background);
     };

     this.makeBases = (d3svg) => {
         let svg = d3svg.Svg();

         let base = [
             { _id: -10, code: 'background' },
             { _id: -15, code: 'forground' },
         ];

         svg.selectAll('g.base')
            .data(base, (d) => { return d._id; })
            .enter()
            .append('g')
            .attr('class', (d) => {
                return 'base ' + d.code;
            });
     }
     this.makeD3Svg = () => {
         let w = window.innerWidth;
         let h = window.innerHeight;

         let svg_tag = this.refs['svg'];
         svg_tag.setAttribute('height',h);
         svg_tag.setAttribute('width',w);

         let d3svg = new D3Svg({
             d3: d3,
             svg: d3.select("#ter-sec_root-svg"),
             x: 0,
             y: 0,
             w: w,
             h: h,
             scale: 1
         });

         this.makeBases(d3svg);

         return d3svg;
     }
     STORE.subscribe((action) => {
         if(action.type=='FETCHED-ER-EDGES' && action.mode=='FIRST') {
             this.draw();
         }
     });

     this.on('mount', () => {
         this.d3svg = this.makeD3Svg();
         this.svg = this.d3svg.Svg();
     });
});

riot.tag2('ter', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});
