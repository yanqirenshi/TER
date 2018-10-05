riot.tag2('app', '<menu-bar brand="{brand()}" site="{site()}" moves="{moves()}" data="{menuBarData()}" callback="{callback}"></menu-bar> <div ref="page-area"></div>', 'app > .page { width: 100vw; height: 100vh; overflow: hidden; display: block; } app .hide,[data-is="app"] .hide{ display: none; }', '', function(opts) {
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

         if (action.type=='FETCHED-GRAPH' && action.mode=='FIRST')
             ACTIONS.fetchErNodes(this.getActiveSchema(), action.mode);

         if (action.type=='FETCHED-ER-NODES')
             ACTIONS.fetchErEdges(this.getActiveSchema(), action.mode);

         if (action.type=='FETCHED-ER-EDGES' && action.mode=='FIRST')
             ACTIONS.fetchTer(action.mode);

         if (action.type=='CHANGE-SCHEMA') {
             ACTIONS.saveConfigAtDefaultSchema(action.data.schemas.active);
             return;
         }

         if (action.type=='CLOSE-ALL-SUB-PANELS' || action.type=='TOGGLE-MOVE-PAGE-PANEL' )
             this.tags['menu-bar'].update();
     })

     window.addEventListener('resize', (event) => {
         this.update();
     });

     if (location.hash=='')
         location.hash='#page01'
});

riot.tag2('menu-bar', '<aside class="menu"> <p ref="brand" class="menu-label" onclick="{clickBrand}"> {opts.brand.label} </p> <ul class="menu-list"> <li each="{opts.site.pages}"> <a class="{opts.site.active_page==code ? \'is-active\' : \'\'}" href="{\'#\' + code}"> {menu_label} </a> </li> </ul> </aside> <div class="move-page-menu {movePanelHide()}" ref="move-panel"> <p each="{opts.moves}"> <a href="{href}" code="{code}" onclick="{clickMovePanelItem}">{label}</a> </p> </div>', 'menu-bar .move-page-menu { z-index: 666665; background: rgba(255,255,255,1); position: fixed; left: 55px; top: 0px; min-width: 111px; height: 100vh; box-shadow: 2px 0px 8px 0px #e0e0e0; padding: 22px 55px 22px 22px; } menu-bar .move-page-menu.hide { display: none; } menu-bar .move-page-menu > p { margin-bottom: 11px; } menu-bar > .menu { z-index: 666666; height: 100vh; width: 55px; padding: 11px 0px 11px 11px; position: fixed; left: 0px; top: 0px; background: rgba(44, 169, 225, 0.8); } menu-bar .menu-label, menu-bar .menu-list a { padding: 0; width: 33px; height: 33px; text-align: center; margin-top: 8px; border-radius: 3px; background: none; color: #ffffff; font-size: 12px; font-weight: bold; padding-top: 7px; } menu-bar .menu-label,[data-is="menu-bar"] .menu-label{ background: rgba(255,255,255,1); color: rgba(44, 169, 225, 0.8); } menu-bar .menu-label.open,[data-is="menu-bar"] .menu-label.open{ background: rgba(255,255,255,1); color: rgba(44, 169, 225, 0.8); width: 44px; border-radius: 3px 0px 0px 3px; text-shadow: 0px 0px 1px #eee; padding-right: 11px; } menu-bar .menu-list a.is-active { width: 44px; padding-right: 11px; border-radius: 3px 0px 0px 3px; background: #ffffff; color: #333333; }', '', function(opts) {
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

riot.tag2('inspector-column', '<h1 class="title is-4">Column Instance</h1> <section-container no="5" title="Name" physical_name="{getVal(\'physical_name\')}" logical_name="{getVal(\'logical_name\')}" callback="{clickEditLogicalName}"> <section-contents physical_name="{opts.physical_name}" logical_name="{opts.logical_name}" callback="{opts.callback}"> <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth"> <tbody> <tr> <th>物理名</th> <td>{opts.physical_name}</td></tr> <tr> <th>論理名</th> <td>{opts.logical_name}</td></tr> </tbody> </table> <div style="text-align: right;"> <button class="button" onclick="{opts.callback}">論理名を変更</button> </div> </section-contents> </section-container> <section-container no="5" title="Type" val="{getVal(\'data_type\')}"> <section-contents val="{opts.val}"> <p>{opts.val}</p> </section-contents> </section-container> <section-container no="5" title="Description" val="{getVal(\'description\')}"> <section-contents val="{opts.val}"> <p>{opts.val}</p> </section-contents> </section-container>', 'inspector-column .section { padding: 11px; padding-top: 0px; } inspector-column section-contents .section { padding-bottom: 0px; padding-top: 0px; } inspector-column .contents, inspector-column .container { width: auto; }', '', function(opts) {
     this.clickEditLogicalName = (e) => {
         if (this.opts.callback)
             this.opts.callback('click-edit-logical-name', this.opts.data);
     };
     this.getVal = (name) => {
         let data = this.opts.data;
         if (!data) return '';

         return data[name];
     };
     STORE.subscribe((action) => {
         if (action.type=='SAVED-COLUMN-INSTANCE-LOGICAL-NAME')
             this.update();
     });
});

riot.tag2('inspector-table-basic', '<section-container no="5" title="Name" name="{opts.name}"> <section-contents name="{opts.name}"> <p>{opts.name}</p> </section-contents> </section-container> <section-container no="5" title="Columns" columns="{opts.columns}"> <section-contents columns="{opts.columns}"> <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth" style="font-size:12px;"> <thead> <tr> <th>物理名</th> <th>論理名</th> <th>タイプ</th></tr> </thead> <tbody> <tr each="{opts.columns}"> <td>{physical_name}</td> <td>{logical_name}</td> <td>{data_type}</td> </tr> </tbody> </table> </section-contents> </section-container>', '', '', function(opts) {
});

riot.tag2('inspector-table-description', '<div class="contents"> <textarea class="textarea" placeholder="Description" style="height:333px;"> {opts.description} </textarea> </div> <section class="section" style="margin-top: 11px;"> <div class="container"> <div class="contents"> <button class="button is-danger">Save</button> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('inspector-table-relationship', '<div class="contents"> <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth"> <thead> <tr><th>Type</th><th>From</th><th>To</th></tr> </thead> <tbody> <tr each="{edges()}"> <td>{data_type}</td> <td>{_port_from._column_instance._table.name}</td> <td>{_port_to._column_instance._table.name}</td> </tr> </tbody> </table> </div>', '', '', function(opts) {
     this.edges = () => {
         if (this.opts && this.opts.data && this.opts.data._edges)
             return this.opts.data._edges

         return [];
     };
});

riot.tag2('inspector-table', '<h1 class="title is-4" style="margin-bottom: 8px;">Table</h1> <div class="tabs"> <ul> <li class="{isActive(\'basic\')}"> <a code="basic" onclick="{clickTab}">Basic</a> </li> <li class="{isActive(\'description\')}"> <a code="description" onclick="{clickTab}">Description</a> </li> <li class="{isActive(\'relationship\')}"> <a code="relationship" onclick="{clickTab}">Relationship</a> </li> </ul> </div> <inspector-table-basic class="{isHide(\'basic\')}" name="{getVal(\'name\')}" columns="{getVal(\'_column_instances\')}"></inspector-table-basic> <inspector-table-description class="{isHide(\'description\')}" description="{getVal(\'description\')}"></inspector-table-description> <inspector-table-relationship class="{isHide(\'relationship\')}" data="{data()}"></inspector-table-relationship>', 'inspector-table .hide { display: none; } inspector-table .section { padding: 11px; padding-top: 0px; } inspector-table section-contents .section { padding-bottom: 0px; padding-top: 0px; } inspector-table .contents, inspector-table .container { width: auto; }', '', function(opts) {
     this.data = () => {
         return this.opts.data;
     };
     this.getVal = (name) => {
         let data = this.opts.data;
         dump(data);

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

riot.tag2('inspector', '<div class="{hide()}"> <inspector-table class="{hideContents(\'table\')}" data="{data()}"></inspector-table> <inspector-column class="{hideContents(\'column-instance\')}" data="{data()}" callback="{opts.callback}"></inspector-column> </div>', 'inspector > div { overflow-y: auto; min-width: 333px; height: 100vh; position: fixed; right: 0px; top: 0px; background: #fff; box-shadow: 0px 0px 8px #888; padding: 22px; } inspector > div.hide { display: none; }', '', function(opts) {
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

riot.tag2('sections-list', '<table class="table"> <tbody> <tr each="{opts.data}"> <td><a href="{hash}">{title}</a></td> </tr> </tbody> </table>', '', '', function(opts) {
});

riot.tag2('page03-modal-logical-name', '<div class="modal {isActive()}"> <div class="modal-background"></div> <div class="modal-content"> <nav class="panel"> <p class="panel-heading"> 論理名の変更 </p> <div class="panel-block" style="background: #fff;"> <span style="margin-right:11px;">テーブル: </span> <span>{tableName()}</span> </div> <div class="panel-block" style="background: #fff;"> <span style="margin-right:11px;">物理名:</span> <span>{physicalName()}</span> </div> <div class="panel-block" style="background: #fff;"> <input class="input" type="text" riot-value="{opts.data.logical_name}" placeholder="論理名" ref="logical_name"> </div> <div class="panel-block" style="background: #fff;"> <button class="button is-danger is-fullwidth" onclick="{clickSaveButton}"> Save </button> </div> </nav> </div> <button class="modal-close is-large" aria-label="close" onclick="{clickCloseButton}"></button> </div>', '', '', function(opts) {
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

riot.tag2('page03-sec_root', '<svg></svg> <operators data="{operators()}" callbak="{clickOperator}"></operators> <inspector callback="{inspectorCallback}"></inspector> <page03-modal-logical-name data="{modalData()}" callback="{modalCallback}"></page03-modal-logical-name>', '', '', function(opts) {
     this.d3svg = null;
     this.ter = new Ter();

     this.modalData = () => {
         let pages = STORE.state().get('site').pages;
         return pages.find((d) => { return d.code == 'page03'; })
                     .modal
                     .logical_name;
     };

     this.state = () => {
         return STORE.state().get('er');
     };

     this.operators = () => {
         let state = STORE.state().get('site').pages.find((d) => { return d.code=='page03'; });
         return state.operators;
     };
     this.clickOperator = (code) => {
         if (code=='move-center')
             return;

         if (code=='save-graph')
             ACTIONS.snapshotAll();
     };
     this.inspectorCallback = (type, data) => {
         if (type=='click-edit-logical-name') {
             STORE.dispatch(ACTIONS.setDataToModalLogicalName('page03', data));
             this.tags['page03-modal-logical-name'].update();
         }
     };
     this.modalCallback = (type, data) => {
         if (type=='click-close-button') {
             STORE.dispatch(ACTIONS.setDataToModalLogicalName('page03', null));
             this.tags['page03-modal-logical-name'].update();
             return;
         }
         if (type=='click-save-button') {
             data.schema_code = STORE.state().get('schemas').active;
             return ACTIONS.saveColumnInstanceLogicalName(data, 'page03');
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

         this.d3svg = this.ter.makeD3svg('page03-sec_root > svg', camera, callbacks);

         return this.d3svg
     };

     STORE.subscribe((action) => {
         if (action.type=='FETCHED-ER-EDGES') {
             let d3svg = this.getD3Svg();

             this.ter.clear(d3svg);
             this.ter.drawTables(d3svg, STORE.state().get('er'));
         }

         if (action.type=='SAVED-COLUMN-INSTANCE-LOGICAL-NAME' && action.from=='page03') {
             this.update();
             this.ter.reDrawTable (action.redraw);
         }
     });
});

riot.tag2('page03', '', '', '', function(opts) {
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

riot.tag2('page02-sec_root', '<svg></svg>', '', '', function(opts) {
     this.d3svg = null;
     this.ter = new Ter();
     this.entity = new Entity();

     this.drawNodes = (d3svg, state)=>{
         let svg = d3svg._svg;
         let nodes = state.nodes.list;
     };
     this.drawEdges = (d3svg, state)=>{
         let svg = d3svg._svg;
         let nodes = state.nodes.ht;
         let edges = state.edges.list;
     };

     STORE.subscribe((action) => {
         if(action.type=='FETCHED-TER' && action.mode=='FIRST') {
             this.d3svg = this.ter.makeD3svg('page02-sec_root > svg');
             new Grid().draw(this.d3svg);

             this.entity.draw(this.d3svg, STORE.state().get('ter'))
         }
     });
});

riot.tag2('page02', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});
