riot.tag2('api', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('api_page_root', '<section-header title="TER: API"></section-header> <page-tabs core="{page_tabs}" callback="{clickTab}"></page-tabs> <div> <api_page_tab_readme class="hide"></api_page_tab_readme> <api_page_tab_tab1 class="hide"></api_page_tab_tab1> <api_page_tab_tab2 class="hide"></api_page_tab_tab2> <api_page_tab_tab3 class="hide"></api_page_tab_tab3> <api_page_tab_help class="hide"></api_page_tab_help> </div> <section-footer></section-footer>', '', '', function(opts) {
     this.page_tabs = new PageTabs([
         {code: 'readme', label: 'README', tag: 'api_page_tab_readme' },
         {code: 'tab1',   label: 'TAB1',   tag: 'api_page_tab_tab1' },
         {code: 'tab2',   label: 'TAB2',   tag: 'api_page_tab_tab2' },
         {code: 'tab3',   label: 'TAB3',   tag: 'api_page_tab_tab3' },
         {code: 'help',   label: 'HELP',   tag: 'api_page_tab_help' },
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

riot.tag2('api_page_tab_help', '<section class="section"> <div class="container"> <h1 class="title">HELP</h1> <h2 class="subtitle"> </h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('api_page_tab_readme', '<section class="section"> <div class="container"> <h1 class="title">README</h1> <h2 class="subtitle"> </h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('api_page_tab_tab1', '<section class="section"> <div class="container"> <h1 class="title">TAB1</h1> <h2 class="subtitle"> </h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('api_page_tab_tab2', '<section class="section"> <div class="container"> <h1 class="title">TAB2</h1> <h2 class="subtitle"> </h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('api_page_tab_tab3', '<section class="section"> <div class="container"> <h1 class="title">TAB3</h1> <h2 class="subtitle"> </h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('app', '<menu-bar brand="{{label:\'RT\'}}" site="{site()}" moves="{[]}"></menu-bar> <div ref="page-area"></div>', 'app > .page { width: 100vw; overflow: hidden; display: block; } app .hide,[data-is="app"] .hide{ display: none; }', '', function(opts) {
     this.site = () => {
         return STORE.state().get('site');
     };

     STORE.subscribe((action)=>{
         if (action.type!='MOVE-PAGE')
             return;

         let tags= this.tags;

         tags['menu-bar'].update();
         ROUTER.switchPage(this, this.refs['page-area'], this.site());
     })

     window.addEventListener('resize', (event) => {
         this.update();
     });

     if (location.hash=='')
         location.hash=STORE.get('site.active_page');
});

riot.tag2('menu-bar', '<aside class="menu"> <p ref="brand" class="menu-label" onclick="{clickBrand}"> {opts.brand.label} </p> <ul class="menu-list"> <li each="{opts.site.pages}"> <a class="{opts.site.active_page==code ? \'is-active\' : \'\'}" href="{\'#\' + code}"> {menu_label} </a> </li> </ul> </aside> <div class="move-page-menu hide" ref="move-panel"> <p each="{moves()}"> <a href="{href}">{label}</a> </p> </div>', 'menu-bar .move-page-menu { z-index: 666665; background: #ffffff; position: fixed; left: 55px; top: 0px; min-width: 111px; height: 100vh; box-shadow: 2px 0px 8px 0px #e0e0e0; padding: 22px 55px 22px 22px; } menu-bar .move-page-menu.hide { display: none; } menu-bar .move-page-menu > p { margin-bottom: 11px; } menu-bar > .menu { z-index: 666666; height: 100vh; width: 55px; padding: 11px 0px 11px 11px; position: fixed; left: 0px; top: 0px; background: #e198b4; } menu-bar .menu-label, menu-bar .menu-list a { padding: 0; width: 33px; height: 33px; text-align: center; margin-top: 8px; border-radius: 3px; background: none; color: #ffffff; font-weight: bold; padding-top: 7px; font-size: 14px; } menu-bar .menu-label,[data-is="menu-bar"] .menu-label{ background: #ffffff; color: #e198b4; } menu-bar .menu-label.open,[data-is="menu-bar"] .menu-label.open{ background: #ffffff; color: #e198b4; width: 44px; border-radius: 3px 0px 0px 3px; text-shadow: 0px 0px 1px #eee; padding-right: 11px; } menu-bar .menu-list a.is-active { width: 44px; padding-right: 11px; border-radius: 3px 0px 0px 3px; background: #ffffff; color: #333333; }', '', function(opts) {
     this.moves = () => {
         let moves = [
             { code: 'link-a', href: '', label: 'Link A' },
             { code: 'link-b', href: '', label: 'Link B' },
             { code: 'link-c', href: '', label: 'Link C' },
         ]
         return moves.filter((d)=>{
             return d.code != this.opts.current;
         });
     };

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

riot.tag2('page-tabs', '<div class="tabs is-boxed" style="padding-left:55px;"> <ul> <li each="{opts.core.tabs}" class="{opts.core.active_tab==code ? \'is-active\' : \'\'}"> <a code="{code}" onclick="{clickTab}">{label}</a> </li> </ul> </div>', 'page-tabs li:first-child { margin-left: 55px; }', '', function(opts) {
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

riot.tag2('section-footer', '<footer class="footer"> <div class="container"> <div class="content has-text-centered"> <p> </p> </div> </div> </footer>', 'section-footer > .footer { background: #ffffff; padding-top: 13px; padding-bottom: 13px; }', '', function(opts) {
});

riot.tag2('section-header-with-breadcrumb', '<section-header title="{opts.title}"></section-header> <section-breadcrumb></section-breadcrumb>', 'section-header-with-breadcrumb section-header > .section,[data-is="section-header-with-breadcrumb"] section-header > .section{ margin-bottom: 3px; }', '', function(opts) {
});

riot.tag2('section-header', '<section class="section"> <div class="container"> <h1 class="title is-{opts.no ? opts.no : 3}"> {opts.title} </h1> <h2 class="subtitle">{opts.subtitle}</h2> <yield></yield> </div> </section>', 'section-header > .section { background: #ffffff; }', '', function(opts) {
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

riot.tag2('sections-list', '<table class="table"> <tbody> <tr each="{opts.data}"> <td><a href="{hash}">{name}</a></td> </tr> </tbody> </table>', '', '', function(opts) {
});

riot.tag2('core', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('core_page_root', '<section-header title="TER: Core"></section-header> <page-tabs core="{page_tabs}" callback="{clickTab}"></page-tabs> <div> <core_page_tab_readme class="hide"></core_page_tab_readme> <core_page_tab_datamodels class="hide"></core_page_tab_datamodels> <core_page_tab_packages class="hide"></core_page_tab_packages> <core_page_tab_classes class="hide"></core_page_tab_classes> <core_page_tab_operators class="hide"></core_page_tab_operators> </div> <section-footer></section-footer>', '', '', function(opts) {
     this.page_tabs = new PageTabs([
         {code: 'readme',     label: 'Readme',      tag: 'core_page_tab_readme' },
         {code: 'datamodels', label: 'Data Models', tag: 'core_page_tab_datamodels' },
         {code: 'packages',   label: 'Packages',    tag: 'core_page_tab_packages' },
         {code: 'classes',    label: 'Classes',     tag: 'core_page_tab_classes' },
         {code: 'operators',  label: 'Operators',   tag: 'core_page_tab_operators' },
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

riot.tag2('core_page_tab_classes', '<section class="section"> <div class="container"> <h1 class="title is-4">List</h1> <h2 class="subtitle"></h2> <section class="section"> <div class="container"> <h1 class="title is-5">TER</h1> <h2 class="subtitle"></h2> <div class="contents"> <table class="table"> <thead> <tr> <th>Name</th> <th>Description</th> </tr> </thead> <tbody> <tr each="{getClasses(\'ter\')}"> <td>{name.toUpperCase()}</td> <td>{description}</td> </tr> </tbody> </table> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title is-5">TER</h1> <h2 class="subtitle"></h2> <div class="contents"> <table class="table"> <thead> <tr> <th>Name</th> <th>Description</th> </tr> </thead> <tbody> <tr each="{getClasses(\'er\')}"> <td>{name.toUpperCase()}</td> <td>{description}</td> </tr> </tbody> </table> </div> </div> </section> </div> </section>', '', '', function(opts) {
     this.getClasses = (group) => {
         return this.classes.filter((d) => {
             return d.group == group;
         });
     };
     this.classes = [
         { group: 'common', package: '', name: 'rsc',                 parent: ''                    },
         { group: 'common', package: '', name: 'rect',                parent: ''                    },
         { group: 'common', package: '', name: 'port',                parent: ''                    },
         { group: 'common', package: '', name: 'point',               parent: ''                    },

         { group: 'ter',    package: '', name: 'resource',            parent: 'shin rsc point rect' },
         { group: 'ter',    package: '', name: 'event',               parent: 'shin rsc point rect' },
         { group: 'ter',    package: '', name: 'comparative',         parent: 'shin rsc point rect' },
         { group: 'ter',    package: '', name: 'correspondence',      parent: 'shin rsc point rect' },
         { group: 'ter',    package: '', name: 'recursion',           parent: 'shin rsc point rect' },
         { group: 'ter',    package: '', name: 'identifier',          parent: 'shin'                },
         { group: 'ter',    package: '', name: 'identifier-instance', parent: 'shin'                },
         { group: 'ter',    package: '', name: 'attribute',           parent: 'shin'                },
         { group: 'ter',    package: '', name: 'attribute-instance',  parent: 'shin'                },
         { group: 'ter',    package: '', name: 'port-ter',            parent: 'shin rsc point'      },
         { group: 'ter',    package: '', name: 'edge-ter',            parent: 'ra'                  },
         { group: 'ter',    package: '', name: 'campus',              parent: 'shin rsc'            },

         { group: 'er',     package: '', name: 'table',               parent: 'shin rsc point rect' },
         { group: 'er',     package: '', name: 'column',              parent: 'shin rsc'            },
         { group: 'er',     package: '', name: 'column-instance',     parent: 'shin rsc'            },
         { group: 'er',     package: '', name: 'port-er',             parent: 'shin rsc port'       },
         { group: 'er',     package: '', name: 'port-er-in',          parent: 'port-er'             },
         { group: 'er',     package: '', name: 'port-er-out',         parent: 'port-er'             },
         { group: 'er',     package: '', name: 'edge-er',             parent: 'ra'                  },

         { group: 'mapper', package: '', name: 'edge-map',            parent: 'ra'                  },
         { group: 'base',   package: '', name: 'camera',              parent: 'shin rsc'            },
         { group: 'base',   package: '', name: 'edge',                parent: 'ra'                  },
         { group: 'base',   package: '', name: 'schema',              parent: 'shin rsc'            },
     ];
});

riot.tag2('core_page_tab_datamodels', '<section class="section"> <div class="container"> <h1 class="title is-4">TER図</h1> <h2 class="subtitle"></h2> <div class="contents"> <p><pre>\n  entity\n    ^\n    |\n    +-------+---------+-------------+-------------+\n    |       |         |             |             |\nresource  event  comparative  correspondence  recursion\n\n\n  identifier ------1:n------> identifier-instance\n  attribute  ------1:n------> attribute-instance\n\n\n  entity ------1:n------> identifier-instance\n  entity ------1:n------> attribute-instance\n\n\n  identifier-instance ------1:n------> port-ter-in\n  identifier-instance ------1:n------> port-ter-out\n\n\n  port-ter-in ------1:n------> edge-ter ------1:n------> port-ter-out</pre></p> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title is-4">ER図</h1> <h2 class="subtitle"></h2> <div class="contents"> <p><pre>\n  table  ------1:n------> column-instance\n\n\n  column ------1:n------> column-instance\n\n\n  column-instance -------1:1------> port-er-in\n  column-instance -------1:1------> port-er-out\n\n\n  port-er-in ------1:1------> edge-er ------1:1------> port-er-out</pre></p> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('core_page_tab_operators', '', '', '', function(opts) {
});

riot.tag2('core_page_tab_packages', '<section class="section"> <div class="container"> <h1 class="title is-4">List</h1> <h2 class="subtitle"></h2> <div class="contents"> <table class="table"> <thead> <tr> <th>Name</th> <th>Description</th> </tr> </thead> <tbody> <tr each="{packages}"> <td>{name.toUpperCase()}</td> <td>{description}</td> </tr> </tbody> </table> </div> </div> </section>', '', '', function(opts) {
     this.packages = [
         { code: 'ter',        name: 'ter',        description: '' },
         { code: 'ter.parser', name: 'ter.parser', description: '' },
         { code: 'ter.db',     name: 'ter.db',     description: '' },
         { code: 'ter-test',   name: 'ter-test',   description: '' },
     ]
});

riot.tag2('core_page_tab_readme', '', '', '', function(opts) {
});

riot.tag2('home', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('home_page_root', '<section-header title="TER Docs"></section-header>', '', '', function(opts) {
});

riot.tag2('web', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('web_page_root', '<section-header title="TER: WEB"></section-header> <section-footer></section-footer>', '', '', function(opts) {
});
