riot.tag2('app', '<menu-bar brand="{brand()}" site="{site()}" moves="{moves()}" callback="{clickSchema}"></menu-bar> <div ref="page-area"></div> <function-menus></function-menus> <inspector></inspector>', 'app > .page { width: 100vw; height: 100vh; overflow: hidden; display: block; } app .hide,[data-is="app"] .hide{ display: none; }', '', function(opts) {
     this.brand = () => {
         let brand = this.getActiveSchema();

         return { label: (brand ? brand.code : 'TER')};
     };
     this.clickSchema = (e) => {
         let schema_code = e.target.getAttribute('CODE');

         STORE.dispatch(ACTIONS.changeSchema(schema_code));

         ACTIONS.fetchEr(this.getActiveSchema());

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
             ACTIONS.fetchEr(this.getActiveSchema(), action.mode);

         if (action.type=='FETCHED-ER' && action.mode=='FIRST')
             ACTIONS.fetchTer(action.mode);

         if (action.type=='CHANGE-SCHEMA') {
             ACTIONS.saveConfigAtDefaultSchema(action.data.schemas.active);
             return;
         }
     })

     window.addEventListener('resize', (event) => {
         this.update();
     });

     if (location.hash=='')
         location.hash='#page01'
});

riot.tag2('function-menus', '<div> <a class="button is-primary">Save Config</a> <a class="button is-link">Save ER</a> <a class="button is-info">Move Center</a> </div>', 'function-menus > div { position: fixed; right: 11px; bottom: 11px; }', '', function(opts) {
});

riot.tag2('menu-bar', '<aside class="menu"> <p ref="brand" class="menu-label" onclick="{clickBrand}"> {opts.brand.label} </p> <ul class="menu-list"> <li each="{opts.site.pages}"> <a class="{opts.site.active_page==code ? \'is-active\' : \'\'}" href="{\'#\' + code}"> {menu_label} </a> </li> </ul> </aside> <div class="move-page-menu hide" ref="move-panel"> <p each="{opts.moves}"> <a href="{href}" code="{code}" onclick="{opts.callback}">{label}</a> </p> </div>', 'menu-bar .move-page-menu { z-index: 666665; background: rgba(255,255,255,1); position: fixed; left: 55px; top: 0px; min-width: 111px; height: 100vh; box-shadow: 2px 0px 8px 0px #e0e0e0; padding: 22px 55px 22px 22px; } menu-bar .move-page-menu.hide { display: none; } menu-bar .move-page-menu > p { margin-bottom: 11px; } menu-bar > .menu { z-index: 666666; height: 100vh; width: 55px; padding: 11px 0px 11px 11px; position: fixed; left: 0px; top: 0px; background: rgba(44, 169, 225, 0.8); } menu-bar .menu-label, menu-bar .menu-list a { padding: 0; width: 33px; height: 33px; text-align: center; margin-top: 8px; border-radius: 3px; background: none; color: #ffffff; font-size: 12px; font-weight: bold; padding-top: 7px; } menu-bar .menu-label,[data-is="menu-bar"] .menu-label{ background: rgba(255,255,255,1); color: rgba(44, 169, 225, 0.8); } menu-bar .menu-label.open,[data-is="menu-bar"] .menu-label.open{ background: rgba(255,255,255,1); color: rgba(44, 169, 225, 0.8); width: 44px; border-radius: 3px 0px 0px 3px; text-shadow: 0px 0px 1px #eee; padding-right: 11px; } menu-bar .menu-list a.is-active { width: 44px; padding-right: 11px; border-radius: 3px 0px 0px 3px; background: #ffffff; color: #333333; }', '', function(opts) {
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

     this.clickBrand = () => {
         let panel = this.refs['move-panel'];
         let classes = panel.getAttribute('class').trim().split(' ');

         if (classes.find((d)=>{ return d=='hide'; })) {
             classes = classes.filter((d)=>{ return d!='hide'; });
             this.brandStatus('open');
         } else {
             classes.push('hide');
             this.brandStatus('close');
         }
         panel.setAttribute('class', classes.join(' '));
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

riot.tag2('inspector-column', '<h1 class="title is-4">Column Instance</h1> <section-container no="5" title="Name" physical_name="{getVal(\'physical_name\')}" logical_name="{getVal(\'logical_name\')}"> <section-contents physical_name="{opts.physical_name}" logical_name="{opts.logical_name}"> <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth"> <tbody> <tr> <th>物理名</th> <td>{opts.physical_name}</td></tr> <tr> <th>論理名</th> <td>{opts.logical_name}</td></tr> </tbody> </table> </section-contents> </section-container> <section-container no="5" title="Type" val="{getVal(\'data_type\')}"> <section-contents val="{opts.val}"> <p>{opts.val}</p> </section-contents> </section-container> <section-container no="5" title="Description" val="{getVal(\'description\')}"> <section-contents val="{opts.val}"> <p>{opts.val}</p> </section-contents> </section-container>', 'inspector-column .section { padding: 11px; padding-top: 0px; } inspector-column section-contents .section { padding-bottom: 0px; padding-top: 0px; } inspector-column .contents, inspector-column .container { width: auto; }', '', function(opts) {
     this.getVal = (name) => {
         let data = this.opts.data;
         if (!data) return '';

         return data[name];
     };
});

riot.tag2('inspector-table', '<h1 class="title is-4">Table</h1> <section-container no="5" title="Name" name="{getVal(\'name\')}"> <section-contents name="{opts.name}"> <p>{opts.name}</p> </section-contents> </section-container> <section-container no="5" title="Columns" columns="{getVal(\'_column_instances\')}"> <section-contents columns="{opts.columns}"> <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth"> <thead> <tr> <th>物理名</th> <th>論理名</th> <th>タイプ</th></tr> </thead> <tbody> <tr each="{opts.columns}"> <td>{physical_name}</td> <td>{logical_name}</td> <td>{data_type}</td> </tr> </tbody> </table> </section-contents> </section-container> <section-container no="5" title="Edges" val="{getVal(\'\')}"> <section-contents val="{opts.val}"> <p>{opts.val}</p> </section-contents> </section-container> <section-container no="5" title="Description" val="{getVal(\'description\')}"> <section-contents val="{opts.val}"> <p>{opts.val}</p> </section-contents> </section-container>', 'inspector-table .section { padding: 11px; padding-top: 0px; } inspector-table section-contents .section { padding-bottom: 0px; padding-top: 0px; } inspector-table .contents, inspector-table .container { width: auto; }', '', function(opts) {
     this.getVal = (name) => {
         let data = this.opts.data;
         if (!data) return '';

         return data[name];
     };
});

riot.tag2('inspector', '<div class="{hide()}"> <inspector-table class="{hideContents(\'table\')}" data="{this.data()}"></inspector-table> <inspector-column class="{hideContents(\'column-instance\')}" data="{this.data()}"></inspector-column> </div>', 'inspector > div { overflow-y: auto; min-width: 333px; height: 100vh; position: fixed; right: 0px; top: 0px; background: #fff; box-shadow: 0px 0px 8px #888; padding: 22px; } inspector > div.hide { display: none; }', '', function(opts) {
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
     })
});

riot.tag2('sections-list', '<table class="table"> <tbody> <tr each="{opts.data}"> <td><a href="{hash}">{title}</a></td> </tr> </tbody> </table>', '', '', function(opts) {
});

riot.tag2('page03-sec_root', '<svg></svg>', '', '', function(opts) {
     this.d3svg = null;
     this.ter = new Ter();

     this.getD3Svg = () => {
         if (this.d3svg) return this.d3svg

         let camera = STORE.state().get('er').cameras[0];
         let callbacks = {
             moveEndSvg: (point) => {
                 let camera = STORE.state().get('er').cameras[0];
                 ACTIONS.saveCameraLookAt(camera, point);
             },
             zoomSvg: (scale) => {
                 let camera = STORE.state().get('er').cameras[0];
                 ACTIONS.saveCameraLookMagnification(camera, scale);
             },
             clickSvg: () => {}
         };

         this.d3svg = this.ter.makeD3svg('page03-sec_root > svg', camera, callbacks);

         return this.d3svg
     }

     STORE.subscribe((action) => {
         if (action.type=='FETCHED-ER') {
             let d3svg = this.getD3Svg();

             this.ter.clear(d3svg);
             this.ter.drawTables(d3svg, STORE.state().get('er'));
         }
     });
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

riot.tag2('page02', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('page03', '', '', '', function(opts) {
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
