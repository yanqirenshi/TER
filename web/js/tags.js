riot.tag2('app-page-area', '', '', '', function(opts) {
     this.draw = () => {
         if (this.opts.route)
             ROUTER.draw(this, STORE.get('site.pages'), this.opts.route);
     }
     this.on('mount', () => {
         this.draw();
     });
     this.on('update', () => {
         this.draw();
     });
});

riot.tag2('app', '<github-link href="https://github.com/yanqirenshi/TER" fill="#5BBBE7" color="#ffffff"></github-link> <menu-bar brand="{brand()}" site="{site()}" systems="{systems()}" data="{menuBarData()}" callback="{callback}"></menu-bar> <app-page-area></app-page-area> <modal-pool></modal-pool>', 'app > .page { width: 100vw; height: 100vh; overflow: hidden; display: block; } app .hide,[data-is="app"] .hide{ display: none; }', '', function(opts) {
     this.brand = () => {
         let brand = STORE.get('active.system');

         return { label: (brand ? brand.code : 'TER')};
     };

     this.callback = (type, e) => {
         if (type=='click-brand')
             return ACTIONS.toggleMovePagePanel();

         if (type=='change-system')
             return this.changeSystem(e);
     };

     this.changeSystem = (system) => {
         ACTIONS.changeSystem(system);

         this.tags['menu-bar'].update();
     };

     this.systems = () => {
         let systems = STORE.get('systems.list');

         return systems.map((d) => {
             return {
                 _id: d._id,
                 code: d.code,
                 href: '',
                 label: d.code,
                 description: d.description,
                 _core: d,
             }
         });
     };

     this.on('mount', () => {
         let route = location.hash.substring(1).split('/');

         ACTIONS.movePage({ route: route });
     });

     this.site = () => {
         return STORE.state().get('site');
     };

     this.menuBarData = () => {
         return STORE.state().get('global').menu;
     };

     this.updateMenuBar = () => {
         if (this.tags['menu-bar'])
             this.tags['menu-bar'].update();
     }

     STORE.subscribe((action) => {
         if (action.type=='MOVE-PAGE') {
             this.updateMenuBar();

             this.tags['app-page-area'].update({ opts: { route: action.route }});
         }

         if (action.type=='FETCHED-ENVIRONMENT' && action.mode=='FIRST')
             this.tags['menu-bar'].update();

         if (action.type=='CLOSE-ALL-SUB-PANELS' ||
             action.type=='TOGGLE-MOVE-PAGE-PANEL' ||
             action.type=='OPEN-GLOBAL-MENU-SYSTEM-PANEL' ||
             action.type=='CLOSE-GLOBAL-MENU-SYSTEM-PANEL')
             this.tags['menu-bar'].update();
     })

     window.addEventListener('resize', (event) => {
         this.update();
     });

     if (location.hash=='')
         location.hash='#base'
});

riot.tag2('page-base', '<section class="section"> <div class="container"> <h1 class="title">Systems</h1> <h2 class="subtitle"></h2> <div class="contents"> <table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <th>ID</th> <th>Code</th> <th>Name</th> <th>Description</th> </tr> </thead> <tbody> <tr each="{obj in list()}"> <td> <a href="{idLink(obj._id)}"> {obj._id} </a> </td> <td>{obj.code}</td> <td>{obj.name}</td> <td>{obj.description}</td> </tr> </tbody> </table> </div> </div> </section>', 'page-base { display: block; width: 100vw; height: 100vh; padding-left: 55px; }', '', function(opts) {
     this.idLink = (v) => {
         return location.hash + '/systems/' + v;
     };
     this.list = () => {
         return this.source.systems || [];
     };
     this.on('mount', () => {
         ACTIONS.fetchPagesBasic();
     });

     this.source = {};
     STORE.subscribe((action)=>{
         if (action.type=='FETCHED-PAGES-BASIC') {
             this.source = action.response;
             this.update();
             return;
         }
     });
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

riot.tag2('menu-bar-popup', '<div class="flex-root"> <div> <h1 class="title is-4">System</h1> </div> <div style="flex-grow:1;"> <button each="{obj in opts.source}" class="button system-item" id="{obj._id}" code="{obj.code}" onclick="{clickMovePanelItem}"> {obj.label} </button> </div> <div> <button class="button is-danger" style="width:100%;" onclick="{clickCreateSystem}">Create System</button> </div> </div>', 'menu-bar-popup .flex-root { display: flex; flex-direction: column; height:100%; padding: 22px 22px 11px 22px; } menu-bar-popup .flex-root .system-item { margin-top: 11px; width: 100%; }', '', function(opts) {
     this.clickCreateSystem = () => {
         ACTIONS.openModalCreateSystem();

         ACTIONS.closeGlobalMenuSystemPanel();
     };
     this.clickMovePanelItem = (e) => {
         let id = e.target.getAttribute('id');

         let system = opts.source.find((d) => {
             return d._id == id;
         });

         this.opts.callback('change-system', system._core);

         ACTIONS.closeGlobalMenuSystemPanel();
     };
});

riot.tag2('menu-bar', '<aside class="menu"> <p ref="brand" class="menu-label" onclick="{clickBrand}"> {opts.brand.label} </p> <ul class="menu-list"> <li each="{opts.site.pages}"> <a class="{opts.site.active_page==code ? \'is-active\' : \'\'}" href="{\'#\' + code}"> {menu_label} </a> </li> </ul> </aside> <div class="move-page-menu {movePanelHide()}" ref="move-panel"> <menu-bar-popup source="{opts.systems}" callback="{childrenCallback()}"></menu-bar-popup> </div>', 'menu-bar .move-page-menu { z-index: 666665; background: rgba(255,255,255,1); position: fixed; left: 55px; top: 0px; min-width: 111px; height: 100vh; box-shadow: 2px 0px 8px 0px #e0e0e0; } menu-bar .move-page-menu.hide { display: none; } menu-bar .move-page-menu > p { margin-bottom: 11px; } menu-bar > .menu { z-index: 666666; height: 100vh; width: 55px; padding: 11px 0px 11px 11px; position: fixed; left: 0px; top: 0px; background: rgba(44, 169, 225, 0.8); } menu-bar .menu-label, menu-bar .menu-list a { padding: 0; width: 33px; height: 33px; text-align: center; margin-top: 8px; border-radius: 3px; background: none; color: #ffffff; font-size: 12px; font-weight: bold; padding-top: 7px; } menu-bar .menu-label,[data-is="menu-bar"] .menu-label{ background: rgba(255,255,255,1); color: rgba(44, 169, 225, 0.8); } menu-bar .menu-label.open,[data-is="menu-bar"] .menu-label.open{ background: rgba(255,255,255,1); color: rgba(44, 169, 225, 0.8); width: 45px; border-radius: 3px 0px 0px 3px; text-shadow: 0px 0px 1px #eee; padding-right: 11px; } menu-bar .menu-list a.is-active { width: 45px; padding-right: 11px; border-radius: 3px 0px 0px 3px; background: #ffffff; color: #333333; }', '', function(opts) {
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

         ACTIONS.closeGlobalMenuSystemPanel();
     };
     this.childrenCallback = () => {
         return this.opts.callback;
     };
});

riot.tag2('operators', '<div> <a each="{opts.data}" class="button {color}" code="{code}" onclick="{click}"> {name} </a> </div>', 'operators > div { position: fixed; right: 11px; bottom: 11px; } operators .button { display: block; margin-top: 11px; }', '', function(opts) {
     this.click = (e) => {
         this.opts.callbak(e.target.getAttribute('code'), e);
     };
});

riot.tag2('page-tabs-with-selecter', '<div class="tabs is-boxed"> <ul> <li style="margin-right:11px;"> <div class="select"> <select> <option each="{obj in opts.source}" selected="{isSelect(obj)}"> {obj.code + ⁗: ⁗ + obj.name} </option> </select> </div> </li> <li each="{opts.core.tabs}" class="{opts.core.active_tab==code ? \'is-active\' : \'\'}"> <a code="{code}" onclick="{clickTab}">{label}</a> </li> </ul> </div>', 'page-tabs-with-selecter li:first-child { margin-left: 11px; } page-tabs-with-selecter .select select { border: none; }', '', function(opts) {
     this.isSelect = (obj) => {
         let active = opts.active;

         return obj._id==active._id;
     };

     this.clickTab = (e) => {
         let code = e.target.getAttribute('code');
         this.opts.callback(e, 'CLICK-TAB', { code: code });
     };
});

riot.tag2('page-tabs', '<div class="tabs is-boxed"> <ul> <li each="{opts.core.tabs}" class="{opts.core.active_tab==code ? \'is-active\' : \'\'}"> <a code="{code}" onclick="{clickTab}">{label}</a> </li> </ul> </div>', 'page-tabs li:first-child { margin-left: 11px; }', '', function(opts) {
     this.clickTab = (e) => {
         let code = e.target.getAttribute('code');
         this.opts.callback(e, 'CLICK-TAB', { code: code });
     };
});

riot.tag2('section-breadcrumb', '<nav class="breadcrumb" aria-label="breadcrumbs"> <ul> <li each="{path()}" class="{active ? \'is-active\' : \'\'}"> <a href="{href}" aria-current="page">{label}</a> </li> </ul> </nav>', '', '', function(opts) {
     this.label = (node, is_last, node_name) => {
         if (node.menu_label)
             return node.menu_label;

         if (node.regex)
             return node_name;

         return is_last ? node_name : node.code;
     };
     this.active = (node, is_last) => {
         if (is_last)
             return true;

         if (!node.tag)
             return true;

         return false;
     };
     this.makeData = (routes, href, path) => {
         if (!path || path.length==0)
             return null;

         let node_name = path[0];
         let node = routes.find((d) => {
             if (d.regex) {
                 return d.regex.exec(node_name);
             } else {
                 return d.code == node_name;
             }
         });

         if (!node) {
             console.warn(routes);
             console.warn(path);
             throw new Error ('なんじゃこりゃぁ!!')
         }

         let sep = href=='#' ? '' : '/';
         let node_label = node.regex ? node_name : node.code;
         let new_href = href + sep + node_label;

         let is_last = path.length == 1;

         let crumb = [{
             label: this.label(node, is_last, node_name),
             href: new_href,
             active: this.active(node, is_last),
         }]

         if (is_last==1)
             return crumb;

         return crumb.concat(this.makeData(node.children, new_href, path.slice(1)))
     };
     this.path = () => {
         let hash = location.hash;
         let path = hash.split('/');

         let routes = STORE.get('site.pages');

         if (path[0] && path[0].substr(0,1)=='#')
             path[0] = path[0].substr(1);

         return this.makeData(routes, '#', path);
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

riot.tag2('inspector-column', '<section class="section"> <div class="container"> <h1 class="title is-5">Column Instance</h1> <h2 class="subtitle" style="font-size: 0.8rem;"> <span>{physicalName()}</span> : <span>{logicalName()}</span> </h2> </div> </section> <page-tabs core="{page_tabs}" callback="{clickTab}"></page-tabs> <div style="margin-top:22px;"> <inspector-column-basic class="hide" source="{columnData()}" callback="{opts.callback}"></inspector-column-basic> <inspector-column-description class="hide" source="{columnData()}" callback="{opts.callback}"></inspector-column-description> </div>', 'inspector-column .section { padding: 11px; padding-top: 0px; } inspector-column section-contents .section { padding-bottom: 0px; padding-top: 0px; } inspector-column .contents, inspector-column .container { width: auto; }', '', function(opts) {
     this.columnData = () => {
         if (!opts.source)
             return null;
         if (opts.source._class!='COLUMN-INSTANCE')
             return null;
         return opts.source
     };
     this.physicalName = () => {
         let data = this.columnData();

         if (!data) return '';

         return data.physical_name;
     };
     this.logicalName = () => {
         let data = this.columnData();

         if (!data) return '';

         return data.logical_name;
     }

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

riot.tag2('inspector-entity-basic', '<div style="margin-top:22px;"> <table class="table is-bordered is-narrow is-hoverable"> <tbody> <tr> <th>Type</th> <td>{dataType()}</td> </tr> <tr> <th>Code</th> <td>{entityCode()}</td> </tr> <tr> <th>Name</th> <td>{entityName()}</td> </tr> </tbody> </table> </div>', '', '', function(opts) {
     this.entityName = () => {
         let data = this.opts.entity;

         if (!data) return '';

         return data._core.name;
     }
     this.dataType = () => {
         let data = this.opts.entity;

         if (!data) return '';

         return data._class;
     }

     this.entityCode = () => {
         let data = this.opts.entity;

         if (!data) return '';

         return data._core.code;
     }
});

riot.tag2('inspector-entity-ports-positions', '<h1 class="title is-6" style="margin-bottom:11px;">Positions</h1> <table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <th rowspan="2">ID</th> <th colspan="3">Position</th> </tr> <tr> <th>x</th> <th>y</th> <th>degree</th> </tr> </thead> <tbody> <tr each="{port in opts.ports}"> <td>{port._core._id}</td> <td>{Math.floor(port.position.x * 100)/100}</td> <td>{Math.floor(port.position.y * 100)/100}</td> <td> <input class="input" type="text" placeholder="Degree" riot-value="{port._core.position}" ref="degree-{port._core._id}"> <button class="button" onclick="{clickSaveDegree}" port-id="{port._core._id}">Save</button> </td> </tr> </tbody> </table>', 'inspector-entity-ports-positions { display: block; } inspector-entity-ports-positions .table td { vertical-align: middle; } inspector-entity-ports-positions .table td .input { text-align: right; width:66px; }', '', function(opts) {
         this.getDegree = (port_id) => {
             let key = 'degree-'+port_id;
             let str = this.refs[key].value;

             return parseFloat(str);
         };
         this.clickSaveDegree = (e) => {
             let port_id = e.target.getAttribute('port-id');

             let port = opts.ports.find((d) => { return d._id = port_id; });
             let degree = this.getDegree(port_id);

             let schemas = STORE.get('schemas');
             let schema  = schemas.list.find((d) => {
                 return d.code == schemas.active;
             });

             ACTIONS.saveTerPortPosition(schema, port, degree);
         };
});

riot.tag2('inspector-entity-ports-relationships', '<div style="margin-top:22px;"> <table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <th rowspan="3">ID</th> <th colspan="3">Relationship</th> </tr> <tr> <th rowspan="2">from</th> <th colspan="2">to</th> </tr> <tr> <th>entity</th> <th>identifier</th> </tr> </thead> <tbody> <tr each="{port in opts.ports}"> <td>{port._core._id}</td> <td>{fromIdentiferName(port)}</td> <td>{toEntity(port)}</td> <td>{toIdentiferName(port)}</td> </tr> </tbody> </table> </div>', 'inspector-entity-ports-relationships { display: block;}', '', function(opts) {
     this.getEdge = (port) => {
         let port_id = port._core._id;
         let port_direction = port._core.direction;

         let state = STORE.get('ter');
         let edges_index = state.relationships.indexes;

         let edges;
         if (port_direction=="IN")
             edges = edges_index.to[port_id];
         else if (port_direction=="OUT")
             edges = edges_index.from[port_id];
         else
             throw new Error('??? port.direction=' + port_direction);

         for (let key in edges)
             if (edges[key].from_class=='PORT-TER' && edges[key].to_class=='PORT-TER')
                 return edges[key];

         return null;
     };
     this.getToPortID = (state, port) => {
         let edge = this.getEdge(port);
         let port_direction = port._core.direction;
         let ports_ht = state.ports.ht;

         if (port_direction=="IN")
             return ports_ht[edge.from_id];
         else if (port_direction=="OUT")
             return ports_ht[edge.to_id];
         else
             throw new Error('??? port.direction=' + port_direction);
     };
     this.getPortIdentifier = (state, port) => {
         let edges = state.relationships.indexes.to[port._id];

         let identifiers_ht = state.identifier_instances.ht;
         for (let key in edges)
             if (edges[key].from_class=='IDENTIFIER-INSTANCE')
                 return identifiers_ht[edges[key].from_id];

         return null
     }

     this.toIdentifer = (port) => {
         let state = STORE.get('ter');

         let to_port = this.getToPortID(state, port);

         return this.getPortIdentifier(state, to_port);
     }
     this.toIdentiferName = (port) => {
         let identifier = this.toIdentifer(port);

         return identifier ? identifier.name : '';
     };
     this.toEntity = (port) => {
         let identifier = this.toIdentifer(port);

         return identifier ? identifier._entity._core.name : '';
     }
     this.fromIdentifer = (port) => {
         let state = STORE.get('ter');

         return this.getPortIdentifier(state, port);
     }
     this.fromIdentiferName = (port) => {
         let identifier = this.fromIdentifer(port);

         return identifier ? identifier.name : '';
     }
     this.fromEntity = (port) => {
         let identifier = this.fromIdentifer(port);

         return identifier ? identifier._entity._core.name : '';
     }
});

riot.tag2('inspector-entity-ports', '<inspector-entity-ports-relationships ports="{portsData()}"></inspector-entity-ports-relationships> <inspector-entity-ports-positions ports="{portsData()}"></inspector-entity-ports-positions>', 'inspector-entity-ports { display: block; } inspector-entity-ports > * { margin-bottom: 22px; }', '', function(opts) {
     this.portsData = () => {
         let data = this.opts.entity;

         if (!data || !data.ports || data.ports.items.list.length==0)
             return null;

         return data.ports.items.list;
     };
});

riot.tag2('inspector-entity', '<div style="margin-bottom:11px;"> <h1 class="title is-5">{entityName()}</h1> </div> <page-tabs core="{page_tabs}" callback="{clickTab}"></page-tabs> <div class="tabs"> <inspector-entity-basic class="hide" entity="{entityData()}"></inspector-entity-basic> <inspector-entity-ports class="hide" entity="{entityData()}"></inspector-entity-ports> </div>', '', '', function(opts) {
     this.page_tabs = new PageTabs([
         {code: 'basic', label: 'Basic', tag: 'inspector-entity-basic' },
         {code: 'ports', label: 'Ports', tag: 'inspector-entity-ports' },
     ]);

     this.on('mount', () => {
         this.page_tabs.switchTab(this.tags)
         this.update();
     });

     this.clickTab = (e, action, data) => {
         if (this.page_tabs.switchTab(this.tags, data.code))
             this.update();
     };

     this.entityName = () => {
         let data = this.entityData();

         if (!data) return '';

         return data._core.name;
     }
     this.entityData = () => {
         let data = this.opts.source;

         if (!data) return null;
         dump(data._class);
         if (data._class=='RESOURCE' ||
             data._class=='RESOURCE-SUBSET' ||
             data._class=='EVENT' ||
             data._class=='EVENT-SUBSET' ||
             data._class=='COMPARATIVE')
             return data;

         return null;
     };
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

riot.tag2('inspector-table', '<div> <h1 class="title is-4" style="margin-bottom: 8px;">Table</h1> </div> <div style="margin-bottom:11px;"> <div class="tabs"> <ul> <li class="{isActive(\'basic\')}"> <a code="basic" onclick="{clickTab}">Basic</a> </li> <li class="{isActive(\'description\')}"> <a code="description" onclick="{clickTab}">Description</a> </li> <li class="{isActive(\'relationship\')}"> <a code="relationship" onclick="{clickTab}">Relationship</a> </li> </ul> </div> </div> <div style="flex-grow:1;"> <inspector-table-basic class="{isHide(\'basic\')}" name="{getVal(\'name\')}" columns="{getVal(\'_column_instances\')}"></inspector-table-basic> <inspector-table-description class="{isHide(\'description\')}" data="{tableData()}" callback="{this.opts.callback}"></inspector-table-description> <inspector-table-relationship class="{isHide(\'relationship\')}" data="{tableData()}"></inspector-table-relationship> </div>', 'inspector-table { height:100%; display:flex; flex-direction: column; } inspector-table .hide { display: none; } inspector-table .section { padding: 11px; padding-top: 0px; } inspector-table section-contents .section { padding-bottom: 0px; padding-top: 0px; } inspector-table .contents, inspector-table .container { width: auto; }', '', function(opts) {
     this.tableData = () => {
         if (!this.opts.data)
             return null;

         if (this.opts.data._class!='TABLE')
             return null;

         return this.opts.data;
     };
     this.getVal = (name) => {
         let data = this.tableData();

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

riot.tag2('inspector', '<div class="{hide()}"> <inspector-table class="{hideContents(\'table\')}" data="{data()}" callback="{opts.callback}"></inspector-table> <inspector-column class="{hideContents(\'column-instance\')}" source="{data()}" callback="{opts.callback}"></inspector-column> <inspector-entity class="{hideContents(\'entity\')}" source="{data()}" callback="{opts.callback}"></inspector-entity> </div>', 'inspector > div { overflow-y: auto; min-width: 333px; max-width: 888px; height: 100vh; position: fixed; right: 0px; top: 0px; background: #fff; box-shadow: 0px 0px 8px #888; padding: 22px; } inspector > div.hide { display: none; } inspector .section > .container > .contents { padding-left:22px;}', '', function(opts) {
     this.state = () => { return STORE.state().get('inspector'); } ;
     this.data = () => {
         return this.state().data;
     };
     this.hideContents = (type) => {
         let data = this.data();

         if (!data)
             return 'hide';

         if (data._class == type.toUpperCase())
             return '';

         if (data._class=='RESOURCE' ||
             data._class=='RESOURCE-SUBSET' ||
             data._class=='EVENT' ||
             data._class=='EVENT-SUBSET' ||
             data._class=='COMPARATIVE')
             if (type=='entity')
                 return '';

         return 'hide';
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

riot.tag2('page-er', '<div style="margin-left:55px; padding-top: 22px;"> <page-tabs-with-selecter core="{page_tabs}" source="{schemas()}" active="{activeSchema()}" callback="{clickTab}"></page-tabs-with-selecter> </div> <div class="tabs"> <page-er_tab-graph class="hide"></page-er_tab-graph> <page-er_tab-tables class="hide"></page-er_tab-tables> <page-er_tab-columns class="hide"></page-er_tab-columns> </div>', 'page-er page-tabs-with-selecter { display: flex; flex-direction: column; } page-er page-tabs-with-selecter li:first-child { margin-left: 88px; } page-er { display: flex; flex-direction: column; width: 100vw; height: 100vh; } page-er .tabs { flex-grow: 1; }', '', function(opts) {
     this.startFirstLoad = () => {
         let active_schema = this.activeSchema();

         if (!active_schema)
             return;

         ACTIONS.fetchErEnvironment(active_schema.code, 'FIRST');
     };
     this.on('mount', () => {
         this.startFirstLoad();
     });
     STORE.subscribe((action) => {
         if (action.mode=='FIRST') {
             if (action.type=='FETCHED-ER-ENVIRONMENT')
                 ACTIONS.fetchErNodes(this.activeSchema(), action.mode);

             if (action.type=='FETCHED-ER-NODES')
                 ACTIONS.fetchErEdges(this.activeSchema(), action.mode);

             if (action.type=='FETCHED-ER-EDGES') {
                 this.update();
             }
         }

         if (action.type=='CHANGE-SYSTEM') {
             this.startFirstLoad();
             return;
         }
     });

     this.schemas = () => {
         let system = STORE.get('active.system');

         return system ? system.schemas : [];
     }
     this.activeSchema = () => {
         return STORE.get('active.er.schema');
     }

     this.page_tabs = new PageTabs([
         { code: 'graph',   label: 'Graph',   tag: 'page-er_tab-graph' },
         { code: 'tables',  label: 'Tables',  tag: 'page-er_tab-tables' },
         { code: 'columns', label: 'Columns', tag: 'page-er_tab-columns' },
     ]);

     this.on('mount', () => {
         this.page_tabs.switchTab(this.tags)
         this.update();
     });

     this.clickTab = (e, action, data) => {
         if (this.page_tabs.switchTab(this.tags, data.code))
             this.update();
     };
});

riot.tag2('page-er_tab-columns', '', '', '', function(opts) {
});

riot.tag2('page-er_tab-graph', '<svg></svg> <operators data="{operators()}" callbak="{clickOperator}"></operators> <inspector callback="{inspectorCallback}"></inspector>', '', '', function(opts) {
     this.sketcher = null;
     this.painter = new Er({
         callbacks: {
             table: {
                 move: {
                     end: (d) => {
                         let state = STORE.state().get('schemas');
                         let code = state.active;
                         let schema = state.list.find((d) => { return d.code == code; });

                         ACTIONS.savePosition(schema, d);
                     }
                 },
                 resize: (table) => {
                     let state = STORE.state().get('schemas');
                     let code = state.active;
                     let schema = state.list.find((d) => { return d.code == code; });

                     ACTIONS.saveTableSize(schema, table);
                 },
                 header: {
                     click: (d) => {
                         STORE.dispatch(ACTIONS.setDataToInspector(d));
                     }
                 },
                 columns: {
                     click: (d) => {
                         STORE.dispatch(ACTIONS.setDataToInspector(d));
                     }
                 },
             }
         }
     });

     this.modal_target_table = null;

     this.modalData = () => {
         let pages = STORE.state().get('site').pages;
         return pages.find((d) => { return d.code == 'er'; })
                     .modal
                     .logical_name;
     };

     this.state = () => {
         return STORE.get('er');
     };

     this.operators = () => {
         let state = STORE.state().get('site').pages.find((d) => { return d.code=='er'; });
         return state.operators;
     };
     this.clickOperator = (code, e) => {
         if (code=='move-center')
             return;

         if (code=='save-graph')
             ACTIONS.snapshotAll();

         if (code=='download') {
             let erapp = new ErApp();
             let file_name = STORE.get('schemas.active') + '.er';

             erapp.downloadJson(file_name, erapp.stateER2Json(STORE.state().get('er')));
         }
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

     this.getCamera = () => {
         let active_schema = STORE.get('active.er.schema');
         let schemas = STORE.get('er.schemas');

         let schema = schemas.ht[active_schema._id];

         let camera = schema.cameras[0];
         if (!camera)
             return null;

         return schema.cameras[0].camera;
     };
     this.makeSketcher = () => {
         let camera = this.getCamera();

         return new Sketcher({
             selector: 'page-er_tab-graph > svg',
             x: camera.look_at.X,
             y: camera.look_at.Y,
             w: window.innerWidth,
             h: window.innerHeight,
             scale: camera.magnification,
             callbacks: {
                 svg: {
                     click: () => {
                         STORE.dispatch(ACTIONS.closeAllSubPanels());
                     },
                     move: {
                         end: (position) => {
                             let camera = this.state().cameras.list[0];
                             let state = STORE.get('schemas');
                             let schema = state.list.find((d) => {
                                 return d.code==state.active;
                             });

                             ACTIONS.saveErCameraLookAt(schema, camera, point);
                         },
                     },
                     zoom: (scale) => {
                         let camera = this.state().cameras.list[0];
                         let state = STORE.get('schemas');
                         let schema = state.list.find((d) => {
                             return d.code==state.active;
                         });

                         ACTIONS.saveErCameraLookMagnification(schema, camera, scale);
                     }
                 }
             }
         });
     };

     this.on('update', () => {
         if (!this.sketcher) {
             this.sketcher = this.makeSketcher();
             this.sketcher.makeCampus();
         } else {
             this.painter.clear(this.sketcher._d3svg);
         }

         let d3svg = this.sketcher._d3svg;

         this.painter.drawTables(d3svg, STORE.state().get('er'));
     });

     STORE.subscribe(this, (action) => {
         if (action.type=='SAVED-COLUMN-INSTANCE-LOGICAL-NAME' && action.from=='er') {
             this.update();
             this.painter.reDrawTable (action.redraw);
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

riot.tag2('page-er_tab-tables', '', '', '', function(opts) {
});

riot.tag2('modal-create-entity', '<div class="modal {isActive()}"> <div class="modal-background"></div> <div class="modal-card"> <header class="modal-card-head"> <p class="modal-card-title">Create Entity</p> <button class="delete" aria-label="close" onclick="{clickClose}"></button> </header> <section class="modal-card-body"> <div class="select"> <select ref="entity_type" onchange="{keyUp}"> <option value="">Entity の種類を選択してください。</option> <option value="rs">Resource</option> <option value="ev">Event</option> </select> </div> <input class="input" type="text" placeholder="Code" ref="code" onkeyup="{keyUp}"> <input class="input" type="text" placeholder="Name" ref="name" onkeyup="{keyUp}"> <textarea class="textarea" placeholder="Description" ref="description"></textarea> </section> <footer class="modal-card-foot"> <button class="button" onclick="{clickClose}">Cancel</button> <button class="button is-success" disabled="{isCanNotCreate()}" onclick="{clickCreate}">Create</button> </footer> </div> </div>', 'modal-create-entity .modal-card-foot { display: flex; justify-content: space-between; } modal-create-entity .modal-card-body .input, modal-create-entity .modal-card-body .select { margin-bottom: 11px; }', '', function(opts) {
     this.clickClose = () => {
         ACTIONS.closeModalCreateEntity();
     };
     this.clickCreate = () => {
         ACTIONS.createTerEntity({
             type: this.refs.entity_type.value,
             code: this.refs.code.value.trim(),
             name: this.refs.name.value.trim(),
             description: this.refs.description.value.trim(),
         })
     };
     this.isActive = () => {
         return STORE.get('modals.create-entity') ? 'is-active' : '';
     };
     this.isCanNotCreate = () => {
         if (this.refs.entity_type.value.length==0)
             return true;

         if (this.refs.code.value.trim().length==0)
             return true;

         if (this.refs.name.value.trim().length==0)
             return true;

         return false;
     };
     this.keyUp = () => {
         this.update();
     };
     STORE.subscribe((action)=>{
         if (action.type=='OPEN-MODAL-CREATE-ENTITY') {
             this.update();
             return;
         }
         if (action.type=='CLOSE-MODAL-CREATE-ENTITY') {
             this.update();
             return;
         }
         if (action.type=='CREATED-ENTITY') {
             ACTIONS.closeModalCreateEntity();
             return;
         }
     });
});

riot.tag2('modal-create-system', '<div class="modal {isActive()}"> <div class="modal-background"></div> <div class="modal-card"> <header class="modal-card-head"> <p class="modal-card-title">Create System</p> <button class="delete" aria-label="close" onclick="{clickClose}"></button> </header> <section class="modal-card-body"> <input class="input" type="text" placeholder="Code" ref="code" onkeyup="{keyUp}"> <input class="input" type="text" placeholder="Name" ref="name" onkeyup="{keyUp}"> <textarea class="textarea" placeholder="Description" ref="description"></textarea> </section> <footer class="modal-card-foot"> <button class="button" onclick="{clickClose}">Cancel</button> <button class="button is-success" disabled="{isCanNotCreate()}" onclick="{clickCreate}">Create</button> </footer> </div> </div>', 'modal-create-system .modal-card-foot { display: flex; justify-content: space-between; } modal-create-system .modal-card-body .input { margin-bottom: 11px; }', '', function(opts) {
     this.clickClose = () => {
         ACTIONS.closeModalCreateSystem();
     };
     this.clickCreate = () => {
         ACTIONS.createSystem({
             code: this.refs.code.value.trim(),
             name: this.refs.name.value.trim(),
             description: this.refs.description.value.trim(),
         })
     };
     this.isActive = () => {
         return STORE.get('modals.create-system') ? 'is-active' : '';
     };
     this.isCanNotCreate = () => {
         if (this.refs.code.value.trim().length==0)
             return true;

         if (this.refs.name.value.trim().length==0)
             return true;

         return false;
     };
     this.keyUp = () => {
         this.update();
     };
     STORE.subscribe((action)=>{
         if (action.type=='OPEN-MODAL-CREATE-SYSTEM') {
             this.update();
             return;
         }
         if (action.type=='CLOSE-MODAL-CREATE-SYSTEM') {
             this.update();
             return;
         }
         if (action.type=='CREATED-SYSTEM') {
             ACTIONS.closeModalCreateSystem();
             return;
         }
     });
});

riot.tag2('modal-pool', '<modal-create-system></modal-create-system> <modal-create-entity></modal-create-entity>', '', '', function(opts) {
});

riot.tag2('page-base-camera-list', '<section class="section"> <div class="container"> <h1 class="title is-4">Camera</h1> <h2 class="subtitle"></h2> <div if="{opts.source.length==0}"> <p>Camera は持っていません。</p> </div> <div if="{opts.source.length!=0}"> <table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <th rowspan="3" colspan="2">Owner</th> <th colspan="8">Camera</th> </tr> <tr> <th rowspan="2">id</th> <th rowspan="2">code</th> <th rowspan="2">name</th> <th colspan="3">Look at</th> <th rowspan="2">magification</th> <th rowspan="2">description</th> </tr> <tr> <th>x</th> <th>y</th> <th>z</th> </tr> </thead> <tbody> <tr each="{obj in opts.source}"> <td>{obj.owner._id}</td> <td>{obj.owner.name}</td> <td>{obj.camera._id}</td> <td>{obj.camera.code}</td> <td>{obj.camera.name}</td> <td>{obj.camera.look_at.x}</td> <td>{obj.camera.look_at.y}</td> <td>{obj.camera.look_at.z}</td> <td>{obj.camera.magnification}</td> <td>{obj.camera.description}</td> </tr> </tbody> </table> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('page-base-campuses', '<section class="section"> <div class="container"> <h1 class="title">Campuses</h1> <h2 class="subtitle"></h2> <div each="{obj in opts.source}"> <div class="contetns" style="margin-left:22px;"> <table class="table is-bordered is-striped is-narrow is-hoverable"> <tbody> <tr> <th>ID</th> <td>{obj._id}</td> </tr> <tr> <th>Code</th> <td>{obj.code}</td> </tr> <tr> <th>Name</th> <td>{obj.name}</td> </tr> <tr> <th>Description</th> <td>{obj.description}</td> </tr> </tbody> </table> </div> <page-base-camera-list source="{obj.cameras}"></page-base-camera-list> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('page-base-schemas', '<section class="section"> <div class="container"> <h1 class="title">Schemas</h1> <h2 class="subtitle"></h2> <div each="{obj in opts.source}"> <div class="contetns" style="margin-left:22px;"> <table class="table is-bordered is-striped is-narrow is-hoverable"> <tbody> <tr> <th>ID</th> <td>{obj._id}</td> </tr> <tr> <th>Code</th> <td>{obj.code}</td> </tr> <tr> <th>Name</th> <td>{obj.name}</td> </tr> <tr> <th>Description</th> <td>{obj.description}</td> </tr> </tbody> </table> </div> <page-base-camera-list source="{obj.cameras}"></page-base-camera-list> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('page-system', '<div class="page-root"> <div style="padding: 22px 33px;"> <section-breadcrumb></section-breadcrumb> </div> <section class="section"> <div class="container"> <h1 class="title">Systems</h1> <h2 class="subtitle"></h2> <div class="contetns" style="margin-left:22px;"> <table class="table is-bordered is-striped is-narrow is-hoverable"> <tbody> <tr> <th>ID</th> <td>{systemVal(\'id\')}</td> </tr> <tr> <th>Code</th> <td>{systemVal(\'code\')}</td> </tr> <tr> <th>Name</th> <td>{systemVal(\'name\')}</td> </tr> <tr> <th>Description</th> <td>{systemVal(\'description\')</td> </tr>                         </tbody>                     </table>                 </div>             </div>         </section>         <page-base-campuses source={this.source.campuses}></page-base-campuses>         <page-base-schemas source={this.source.schemas}></page-base-schemas>     </div>}', '', '', function(opts) {
     this.systemVal = (key) => {
         if (!this.source.system)
             return '';

         return this.source.system[key];
     }

     this.on('mount', () => {
         let id = location.hash.split('/').reverse()[0] * 1;

         ACTIONS.fetchPagesSystem(id);
     });
     this.source = {
         system: null,
         campuses: [],
         schemas: [],
     }
     STORE.subscribe((action) => {
         if (action.type=='FETCHED-PAGES-SYSTEM') {
             this.source = action.response;
             this.update();

             return;
         }
     });
});

riot.tag2('page-ter-controller', '<button class="button" onclick="{clickCreateEntity}">Create Entity</button> <button class="button">Create Relationship</button> <button class="button">Save Graph</button> <button class="button" onclick="{clickDownload}">Download</button>', 'page-ter-controller { position: fixed; right: 22px; bottom: 22px; display: flex; flex-direction: column; } page-ter-controller > * { margin-top: 22px; }', '', function(opts) {
     this.clickDownload = () => {
         let erapp = new ErApp();
         let file_name = STORE.get('schemas.active') + '.ter';

         erapp.downloadJson(file_name, erapp.stateTER2Json(STORE.state().get('ter')));
     }

     this.clickCreateEntity = () => {
         ACTIONS.openModalCreateEntity();
     };
});

riot.tag2('page-ter', '<div style="margin-left:55px; padding-top: 22px;"> <page-tabs-with-selecter core="{page_tabs}" source="{campuses()}" active="{activeCampus()}" callback="{clickTab}"></page-tabs-with-selecter> </div> <div class="tabs"> <page-ter_tab-graph class="hide"></page-ter_tab-graph> <page-ter_tab-entities class="hide"></page-ter_tab-entities> <page-ter_tab-identifiers class="hide"></page-ter_tab-identifiers> <page-ter_tab-attributes class="hide"></page-ter_tab-attributes> </div>', 'page-ter page-tabs-with-selecter { display: flex; flex-direction: column; } page-ter page-tabs-with-selecter li:first-child { margin-left: 88px; } page-ter { display: flex; flex-direction: column; width: 100vw; height: 100vh; } page-ter .tabs { flex-grow: 1; }', '', function(opts) {
     this.campuses = () => {
         let system = STORE.get('active.system');

         return system ? system.campuses : [];
     }
     this.activeCampus = () => {
         return STORE.get('active.ter.campus');
     }

     STORE.subscribe(this, (action) => {
         if(action.type=='SAVED-TER-PORT-POSITION') {
             let state = STORE.get('ter');

             let port_id = action.target._id;
             let edges = state.relationships.indexes.to[port_id];
             let edge = null;
             for (let key in edges) {
                 let edge_tmp = edges[key];
                 if (edge_tmp.from_class=="IDENTIFIER-INSTANCE")
                     edge = edge_tmp;
             }

             this.painter.movePort(edge._from._entity, action.target);
         }

         if (action.type=='FETCHED-ENVIRONMENT') {
             this.startFirstLoadData();
             return;
         }

         if (action.mode=='FIRST') {

             if (action.type=='FETCHED-TER-ENVIRONMENT')
                 ACTIONS.fetchTerEntities(action.schema, action.mode);

             if (action.type=='FETCHED-TER-ENTITIES')
                 ACTIONS.fetchTerIdentifiers(action.schema, action.mode);

             if (action.type=='FETCHED-TER-IDENTIFIERS')
                 ACTIONS.fetchTerAttributes(action.schema, action.mode);

             if (action.type=='FETCHED-TER-ATTRIBUTES')
                 ACTIONS.fetchTerPorts(action.schema, action.mode);

             if (action.type=='FETCHED-TER-PORTS')
                 ACTIONS.fetchTerEdges(action.schema, action.mode);

             if(action.type=='FETCHED-TER-EDGES')
                 ACTIONS.fetchedAllDatas(action.mode);

             if(action.type=='FETCHED-ALL-DATAS') {
                 this.update();
             }
         }

         if (action.type=='CHANGE-SYSTEM') {
             this.startFirstLoadData();
             return;
         }
     });

     this.startFirstLoadData = () => {
         let active_campus = this.activeCampus();

         if (!active_campus)
             return;

         ACTIONS.fetchTerEnvironment(active_campus.code, 'FIRST');
     };
     this.on('mount', () => {
         this.startFirstLoadData();
     });

     this.page_tabs = new PageTabs([
         {code: 'graph',       label: 'Graph',       tag: 'page-ter_tab-graph' },
         {code: 'entities',    label: 'Entities',    tag: 'page-ter_tab-entities' },
         {code: 'identifiers', label: 'Identifiers', tag: 'page-ter_tab-identifiers' },
         {code: 'attributes',  label: 'Attributes',  tag: 'page-ter_tab-attributes' },
     ]);

     this.on('mount', () => {
         this.page_tabs.switchTab(this.tags)
         this.update();
     });

     this.clickTab = (e, action, data) => {
         if (this.page_tabs.switchTab(this.tags, data.code))
             this.update();
     };
});

riot.tag2('page-ter_tab-attributes', '<section class="section"> <div class="container"> <div class="contents"> <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" style="font-size:12px;"> <thead> <tr> <th colspan="2">Entity</th> <th colspan="5">Identifier</th> </tr> <tr> <th>Code</th> <th>Name</th> <th>ID</th> <th>Code</th> <th>Name</th> <th>Type</th> <th>Description</th> </tr> </thead> <tbody> <tr each="{obj in list()}"> <td nowrap>{obj._entity._core.code}</td> <td nowrap>{obj._entity._core.name}</td> <td nowrap>{obj._id}</td> <td nowrap>{obj.code}</td> <td nowrap>{obj.name}</td> <td nowrap>{obj.data_type}</td> <td nowrap>{obj.description}</td> </tr> </tbody> </table> </div> </div> </section>', 'page-ter_tab-attributes { display: block; width: 100%; height: 100%; margin-left: 55px; overflow: auto; } page-ter_tab-attributes .table .num{ text-align: right; }', '', function(opts) {
     this.num = (v) => {
         if (!v)
             return '';
         return v.toFixed(2);
     }
     this.list = () => {
         let list = STORE.get('ter.attribute_instances.list');

         return list || [];
     };
});

riot.tag2('page-ter_tab-entities', '<section class="section"> <div class="container"> <div class="contents"> <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" style="font-size:12px;"> <thead> <tr> <th rowspan="2">ID</th> <th rowspan="2">Class</th> <th rowspan="2">Code</th> <th rowspan="2">Name</th> <th colspan="2">Position</th> <th colspan="2">Size</th> <th rowspan="2">description</th> </tr> <tr> <th>x</th> <th>y</th> <th>w</th> <th>h</th> </tr> </thead> <tbody> <tr each="{obj in list()}"> <td nowrap>{obj._id}</td> <td nowrap>{obj._class}</td> <td nowrap>{obj.code}</td> <td>{obj.name}</td> <td class="num" nowrap>{num(obj.position.x)}</td> <td class="num" nowrap>{num(obj.position.y)}</td> <td class="num" nowrap>{num(obj.size.w)}</td> <td class="num" nowrap>{num(obj.size.h)}</td> <td>{obj.description}</td> </tr> </tbody> </table> </div> </div> </section>', 'page-ter_tab-entities { display: block; width: 100%; height: 100%; margin-left: 55px; overflow: auto; } page-ter_tab-entities .table .num{ text-align: right; }', '', function(opts) {
     this.num = (v) => {
         if (!v)
             return '';
         return v.toFixed(2);
     }
     this.list = () => {
         let list = STORE.get('ter.entities.list');

         return list || [];
     };
});

riot.tag2('page-ter_tab-graph', '<page-ter-controller></page-ter-controller> <svg id="ter-sec_root-svg" ref="svg"></svg> <operators data="{operators()}" callbak="{clickOperator}"></operators> <inspector callback="{inspectorCallback}"></inspector>', '', '', function(opts) {
     this.inspectorCallback = (type, data) => {
     };

     this.operators = () => {
         let state = STORE.state().get('site').pages.find((d) => { return d.code=='ter'; });
         return state.operators;
     };

     this.clickOperator = (code, e) => {
         if (code=='download') {
             let erapp = new ErApp();
             let file_name = STORE.get('schemas.active') + '.ter';

             erapp.downloadJson(file_name, erapp.stateTER2Json(STORE.state().get('ter')));
         }
     };

     this.sketcher = null;

     this.painter = new Ter();

     this.getCamera = () => {
         let active_campus = STORE.get('active.ter.campus');
         let campuses = STORE.get('ter.campuses');

         let campus = campuses.ht[active_campus._id];

         let camera = campus.cameras[0];
         if (!camera)
             return null;

         return campus.cameras[0].camera;
     };
     this.makeSketcher = () => {
         let camera = this.getCamera();

         if (!camera) {
             console.warn('Camera is Empty.');
             return;
         }

         return new Sketcher({
             selector: 'page-ter_tab-graph svg',
             x: camera.look_at.X,
             y: camera.look_at.Y,
             w: window.innerWidth,
             h: window.innerHeight,
             scale: camera.magnification,
             callbacks: {
                 svg: {
                     click: () => {
                         STORE.dispatch(ACTIONS.setDataToInspector(null));
                     },
                     move: {
                         end: (position) => {
                             let state = STORE.get('schemas');
                             let schema = state.list.find((d) => { return d.code==state.active; });
                             let camera = STORE.get('ter.camera');

                             ACTIONS.saveTerCameraLookAt(schema, camera, position);
                         },
                     },
                     zoom: (scale) => {
                         let state = STORE.get('schemas');
                         let schema = state.list.find((d) => { return d.code==state.active; });
                         let camera = STORE.get('ter.camera');

                         ACTIONS.saveTerCameraLookMagnification(schema, camera, scale);
                     }
                 }
             }
         });
     };
     this.draw = () => {
         let svg = this.sketcher.svg();

         let forground  = svg.selectAll('g.base.forground');
         let background = svg.selectAll('g.base.background');
         let state      = STORE.get('ter');

         this.painter
             .data(state)
             .sizing()
             .positioning()
             .draw(forground,
                   background,
                   {
                       entity: {
                           click: (d) => {
                               STORE.dispatch(ACTIONS.setDataToInspector(d));
                               d3.event.stopPropagation();
                           }}
                   });
     };
     this.on('update', ()=>{
         if (!this.sketcher) {
             this.sketcher = this.makeSketcher();
             this.sketcher.makeCampus();
         }

         this.draw();
     });
});

riot.tag2('page-ter_tab-identifiers', '<section class="section"> <div class="container"> <div class="contents"> <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" style="font-size:12px;"> <thead> <tr> <th colspan="2">Entity</th> <th colspan="5">Identifier</th> </tr> <tr> <th>Code</th> <th>Name</th> <th>ID</th> <th>Code</th> <th>Name</th> <th>Type</th> <th>Description</th> </tr> </thead> <tbody> <tr each="{obj in list()}"> <td nowrap>{obj._entity._core.code}</td> <td nowrap>{obj._entity._core.name}</td> <td nowrap>{obj._id}</td> <td nowrap>{obj.code}</td> <td nowrap>{obj.name}</td> <td nowrap>{obj.data_type}</td> <td nowrap>{obj.description}</td> </tr> </tbody> </table> </div> </div> </section>', 'page-ter_tab-identifiers { display: block; width: 100%; height: 100%; margin-left: 55px; overflow: auto; } page-ter_tab-identifiers .table .num{ text-align: right; }', '', function(opts) {
     this.num = (v) => {
         if (!v)
             return '';
         return v.toFixed(2);
     }
     this.list = () => {
         let list = STORE.get('ter.identifier_instances.list');

         return list || [];
     };
});
