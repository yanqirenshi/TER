riot.tag2('api', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('api_page_root', '<section-header title="TER: API"></section-header> <page-tabs core="{page_tabs}" callback="{clickTab}"></page-tabs> <div> <api_page_tab_readme class="hide"></api_page_tab_readme> <api_page_tab_tab1 class="hide"></api_page_tab_tab1> <api_page_tab_tab2 class="hide"></api_page_tab_tab2> <api_page_tab_tab3 class="hide"></api_page_tab_tab3> <api_page_tab_help class="hide"></api_page_tab_help> </div> <section-footer></section-footer>', 'api_page_root > page-tabs { display: block; margin-top:22px; }', '', function(opts) {
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

riot.tag2('app', '<menu-bar brand="{{label:\'RT\'}}" site="{site()}" moves="{[]}"></menu-bar> <div ref="page-area" style="margin-left:55px;"></div>', 'app > .page { width: 100vw; overflow: hidden; display: block; } app .hide,[data-is="app"] .hide{ display: none; }', '', function(opts) {
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

riot.tag2('menu-bar', '<aside class="menu"> <p ref="brand" class="menu-label" onclick="{clickBrand}"> {opts.brand.label} </p> <ul class="menu-list"> <li each="{opts.site.pages}"> <a class="{opts.site.active_page==code ? \'is-active\' : \'\'}" href="{\'#\' + code}"> {menu_label} </a> </li> </ul> </aside> <div class="move-page-menu hide" ref="move-panel"> <p each="{moves()}"> <a href="{href}">{label}</a> </p> </div>', 'menu-bar .move-page-menu { z-index: 666665; background: #ffffff; position: fixed; left: 55px; top: 0px; min-width: 111px; height: 100vh; box-shadow: 2px 0px 8px 0px #e0e0e0; padding: 22px 55px 22px 22px; } menu-bar .move-page-menu.hide { display: none; } menu-bar .move-page-menu > p { margin-bottom: 11px; } menu-bar > .menu { z-index: 666666; height: 100vh; width: 55px; padding: 11px 0px 11px 11px; position: fixed; left: 0px; top: 0px; background: #CF2316; } menu-bar .menu-label, menu-bar .menu-list a { padding: 0; width: 33px; height: 33px; text-align: center; margin-top: 8px; border-radius: 3px; background: none; color: #ffffff; font-weight: bold; padding-top: 7px; font-size: 14px; } menu-bar .menu-label,[data-is="menu-bar"] .menu-label{ background: #ffffff; color: #CF2316; } menu-bar .menu-label.open,[data-is="menu-bar"] .menu-label.open{ background: #ffffff; color: #CF2316; width: 44px; border-radius: 3px 0px 0px 3px; text-shadow: 0px 0px 1px #eee; padding-right: 11px; } menu-bar .menu-list a.is-active { width: 45px; padding-right: 11px; border-radius: 3px 0px 0px 3px; background: #ffffff; color: #333333; }', '', function(opts) {
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

riot.tag2('section-header', '<section class="section"> <div class="container"> <h1 class="title is-{opts.no ? opts.no : 3}"> {opts.title} </h1> <h2 class="subtitle">{opts.subtitle}</h2> <yield></yield> </div> </section>', 'section-header > .section { background: #1D0D37; } section-header > .section .title { color: #fff; } section-header > .section .subtitle { color: #fff; }', '', function(opts) {
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

riot.tag2('subtitle-breadcrumb', '<nav class="breadcrumb" aria-label="breadcrumbs"> <ul> <li each="{path()}"> <a class="{active ? \'is-active\' : \'\'}" href="{href}" aria-current="page">{label}</a> </li> </ul> </nav>', 'subtitle-breadcrumb { display: block; } subtitle-breadcrumb > nav.breadcrumb { padding-left: 22px; }', '', function(opts) {
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

riot.tag2('sections-list', '<table class="table"> <tbody> <tr each="{opts.data}"> <td><a href="{hash}">{name}</a></td> </tr> </tbody> </table>', '', '', function(opts) {
});

riot.tag2('core', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('core_page_root', '<section-header title="TER: Core"></section-header> <page-tabs core="{page_tabs}" callback="{clickTab}"></page-tabs> <div> <core_page_tab_usage class="hide"></core_page_tab_usage> <core_page_tab_datamodels class="hide"></core_page_tab_datamodels> <core_page_tab_packages class="hide"></core_page_tab_packages> <core_page_tab_classes class="hide"></core_page_tab_classes> <core_page_tab_operators class="hide"></core_page_tab_operators> <core_page_tab_readme class="hide"></core_page_tab_readme> </div> <section-footer></section-footer>', 'core_page_root > page-tabs { display: block; margin-top:22px; }', '', function(opts) {
     this.page_tabs = new PageTabs([
         {code: 'usage',      label: 'Usage',       tag: 'core_page_tab_usage' },
         {code: 'datamodels', label: 'Data Models', tag: 'core_page_tab_datamodels' },
         {code: 'packages',   label: 'Packages',    tag: 'core_page_tab_packages' },
         {code: 'classes',    label: 'Classes',     tag: 'core_page_tab_classes' },
         {code: 'operators',  label: 'Operators',   tag: 'core_page_tab_operators' },
         {code: 'readme',     label: 'Readme',      tag: 'core_page_tab_readme' },
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

riot.tag2('core_page_tab_classes-table', '<section class="section"> <div class="container"> <h1 class="title is-5">{opts.label}</h1> <h2 class="subtitle"></h2> <div class="contents"> <table class="table"> <thead> <tr> <th>Package</th> <th>Name</th> <th>Parent</th> <th>Description</th> </tr> </thead> <tbody> <tr each="{rec in opts.data}"> <td> <a href="{⁗#core/packages/⁗+rec.package}"> {rec.package.toUpperCase()} </a> </td> <td> <a href="{⁗#core/classes/⁗+rec.name}"> {rec.name.toUpperCase()} </a> </td> <td>{rec.parent_classes}</td> <td>{rec.file}</td> </tr> </tbody> </table> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('core_page_tab_classes', '<section class="section"> <div class="container"> <h1 class="title is-4">List</h1> <h2 class="subtitle"></h2> <core_page_tab_classes-table label="TER" data="{getClasses(\'ter\')}"></core_page_tab_classes-table> <core_page_tab_classes-table label="ER" data="{getClasses(\'er\')}"></core_page_tab_classes-table> <core_page_tab_classes-table label="Auth" data="{getClasses(\'auth\')}"></core_page_tab_classes-table> <core_page_tab_classes-table label="Mapper" data="{getClasses(\'mapper\')}"></core_page_tab_classes-table> <core_page_tab_classes-table label="Common" data="{getClasses(\'common\')}"></core_page_tab_classes-table> </div> </section>', '', '', function(opts) {
     this.getClasses = (group) => {
         return this.classes.filter((d) => {
             return d.group == group;
         });
     };
     this.classes = [
         { name:'campus',               parent_classes:'shinra:shin rsc',            group:'ter',    package: 'TER', file:'./src/classes/ter/campus.lisp',          },
         { name:'entity',               parent_classes:'shinra:shin rsc',            group:'ter',    package: 'TER', file:'./src/classes/ter/entity.lisp',          },
         { name:'resource',             parent_classes:'entity',                     group:'ter',    package: 'TER', file:'./src/classes/ter/resource.lisp',        },
         { name:'event',                parent_classes:'entity',                     group:'ter',    package: 'TER', file:'./src/classes/ter/event.lisp',           },
         { name:'comparative',          parent_classes:'entity',                     group:'ter',    package: 'TER', file:'./src/classes/ter/comparative.lisp',     },
         { name:'correspondence',       parent_classes:'entity ',                    group:'ter',    package: 'TER', file:'./src/classes/ter/correspondence.lisp',  },
         { name:'recursion',            parent_classes:'entity',                     group:'ter',    package: 'TER', file:'./src/classes/ter/recursion.lisp',       },
         { name:'identifier',           parent_classes:'shinra:shin',                group:'ter',    package: 'TER', file:'./src/classes/ter/identifier.lisp',      },
         { name:'identifier-instance',  parent_classes:'shinra:shin rsc',            group:'ter',    package: 'TER', file:'./src/classes/ter/identifier.lisp',      },
         { name:'attribute',            parent_classes:'shinra:shin',                group:'ter',    package: 'TER', file:'./src/classes/ter/attribute.lisp',       },
         { name:'attribute-instance',   parent_classes:'shinra:shin rsc',            group:'ter',    package: 'TER', file:'./src/classes/ter/attribute.lisp',       },
         { name:'port-ter',             parent_classes:'shinra:shin rsc point',      group:'ter',    package: 'TER', file:'./src/classes/ter/port-ter.lisp',        },
         { name:'edge-ter',             parent_classes:'shinra:ra',                  group:'ter',    package: 'TER', file:'./src/classes/ter/edge-ter.lisp',        },

         { name:'schema',               parent_classes:'shinra:shin rsc',            group:'er',     package: 'TER', file:'./src/classes/base/schema.lisp',         },
         { name:'table',                parent_classes:'shinra:shin rsc point rect', group:'er',     package: 'TER', file:'./src/classes/er/table.lisp',            },
         { name:'column',               parent_classes:'shinra:shin rsc',            group:'er',     package: 'TER', file:'./src/classes/er/column.lisp',           },
         { name:'column-instance',      parent_classes:'shinra:shin rsc',            group:'er',     package: 'TER', file:'./src/classes/er/column.lisp',           },
         { name:'port-er',              parent_classes:'shinra:shin rsc port',       group:'er',     package: 'TER', file:'./src/classes/er/port-er.lisp',          },
         { name:'port-er-in',           parent_classes:'port-er',                    group:'er',     package: 'TER', file:'./src/classes/er/port-er.lisp',          },
         { name:'port-er-out',          parent_classes:'port-er',                    group:'er',     package: 'TER', file:'./src/classes/er/port-er.lisp',          },
         { name:'edge-er',              parent_classes:'shinra:ra',                  group:'er',     package: 'TER', file:'./src/classes/er/edge-er.lisp',          },
         { name:'camera',               parent_classes:'shinra:shin rsc',            group:'er',     package: 'TER', file:'./src/classes/base/camera.lisp',         },

         { name:'ghost-shadow',         parent_classes:'shinra:shin',                group:'auth',   package: 'TER', file:'./src/classes/modeler.lisp',             },
         { name:'modeler',              parent_classes:'shinra:shin',                group:'auth',   package: 'TER', file:'./src/classes/modeler.lisp',             },

         { name:'edge-map',             parent_classes:'shinra:ra',                  group:'mapper', package: 'TER', file:'./src/classes/mapper.lisp',              },

         { name:'point',                parent_classes:'',                           group:'common', package: 'TER', file:'./src/classes/common.lisp',              },
         { name:'rect',                 parent_classes:'',                           group:'common', package: 'TER', file:'./src/classes/common.lisp',              },
         { name:'rsc',                  parent_classes:'',                           group:'common', package: 'TER', file:'./src/classes/common.lisp',              },
         { name:'port',                 parent_classes:'',                           group:'common', package: 'TER', file:'./src/classes/common.lisp',              },
         { name:'edge',                 parent_classes:'shinra:ra',                  group:'common', package: 'TER', file:'./src/classes/edge.lisp',                },
         { name:'edge',                 parent_classes:'shinra:ra',                  group:'common', package: 'TER', file:'./src/base/common.lisp',                 },
     ];
});

riot.tag2('core_page_tab_datamodels-er', '<section class="section"> <div class="container"> <h1 class="title is-4">ER図</h1> <h2 class="subtitle"></h2> <div class="contents"> <p><pre>\n  table  ------1:n------> column-instance\n\n\n  column ------1:n------> column-instance\n\n\n  column-instance -------1:1------> port-er-in\n  column-instance -------1:1------> port-er-out\n\n\n  port-er-in ------1:1------> edge-er ------1:1------> port-er-out</pre></p> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('core_page_tab_datamodels-system', '<section class="section"> <div class="container"> <h1 class="title is-4">共通</h1> <h2 class="subtitle"></h2> <div class="contents"> <p><pre>\n  ghost-shadow ---1:1---> modeler\n\n  system ---1:n---> schema\n  system ---1:n---> campus\n\n  modeler ---1:n---> system <---1:n--- schema\n  modeler ---1:n---> system <---1:n--- campus\n\n  modeler ---1:n---> camera <---1:n--- schema\n  modeler ---1:n---> camera <---1:n--- campus\n                </pre></p> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('core_page_tab_datamodels-ter', '<section class="section"> <div class="container"> <h1 class="title is-4">TER図</h1> <h2 class="subtitle"></h2> <div class="contents"> <p><pre>\n  entity\n    ^\n    |\n    +-------+---------+-------------+-------------+-------------+-------------+\n    |       |         |             |             |             |             |\nresource  event  comparative  correspondence  recursion  resouce-detail  event-detail\n\n\n  identifier ------1:n------> identifier-instance\n  attribute  ------1:n------> attribute-instance\n\n\n  entity ------1:n------> identifier-instance\n  entity ------1:n------> attribute-instance\n\n\n  identifier-instance ------1:n------> port-ter-in\n  identifier-instance ------1:n------> port-ter-out\n\n  recouece : recouece\n  recouece : resouce-detail\n  recouece : recursion\n  resouece : event\n  event    : event-detail\n  event    : event\n\n  port-ter-in ------1:n------> edge-ter ------1:n------> port-ter-out</pre></p> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('core_page_tab_datamodels', '<core_page_tab_datamodels-system></core_page_tab_datamodels-system> <core_page_tab_datamodels-ter></core_page_tab_datamodels-ter> <core_page_tab_datamodels-er></core_page_tab_datamodels-er>', '', '', function(opts) {
});

riot.tag2('core_page_tab_operators', '<section class="section"> <div class="container"> <h1 class="title">Dictionary</h1> <h2 class="subtitle"></h2> <div class="contents"> <table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <th>Type</th> <th>Name</th> <th>Description</th> </tr> </thead> <tbody> <tr each="{operator in operators}"> <td>{operator.type}</td> <td> <a href="{makeHref(operator.tag)}"> {operator.name} </a> </td> <td></td> </tr> </tbody> </table> </div> </div> </section>', '', '', function(opts) {
     this.makeHref = (tag) => {
         return location.hash + '/' + tag;
     }
     this.operators = [
         { name: 'tx-make-relationship',       tag: 'tx-make-relationship',       type: 'Standard Generic Function' },
         { name: 'tx-add-identifier-2-entity', tag: 'tx-add-identifier-2-entity', type: 'Function' },
         { name: 'tx-add-attribute-2-entity',  tag: 'tx-add-attribute-2-entity',  type: 'Function' },
     ];
});

riot.tag2('core_page_tab_packages', '<section class="section"> <div class="container"> <h1 class="title is-4">List</h1> <h2 class="subtitle"></h2> <div class="contents"> <table class="table"> <thead> <tr> <th>Name</th> <th>Description</th> </tr> </thead> <tbody> <tr each="{packages}"> <td> <a href="{\'#core/pakages/\'+name}"> {name.toUpperCase()} </a> </td> <td>{description}</td> </tr> </tbody> </table> </div> </div> </section>', '', '', function(opts) {
     this.packages = [
         { code: 'ter',        name: 'ter',        description: '' },
         { code: 'ter.parser', name: 'ter.parser', description: '' },
         { code: 'ter.db',     name: 'ter.db',     description: '' },
         { code: 'ter-test',   name: 'ter-test',   description: '' },
     ]

});

riot.tag2('core_page_tab_readme', '', '', '', function(opts) {
});

riot.tag2('core_page_tab_usage', '<section class="section"> <div class="container"> <h1 class="title is-5">Entity を追加する。</h1> <h2 class="subtitle"></h2> <div class="contents"> <pre><code></code></pre> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title is-5">Entity へ Identifier を追加する。</h1> <h2 class="subtitle"></h2> <section class="section"> <div class="container"> <h1 class="title is-6">Naive な Identifier の追加</h1> <h2 class="subtitle"></h2> <div class="contents"> <div class="contents"> <pre><code>(tx-add-identifier-2-entity ter.db:*graph*\n                            :campus-code :rbp\n                            :entity-code :user\n                            :code        :image\n                            :name        "更新日時 (エンドユーザー)"\n                            :data-type   "datetime")</code></pre> </div> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title is-6">Foreigner な Identifier の追加</h1> <h2 class="subtitle"></h2> <div class="contents"> <div class="contents"> <pre><code>(tx-add-identifier-2-entity ter.db:*graph*\n                            :campus-code :rbp\n                            :entity-code :user\n                            :code        :image\n                            :name        "更新日時 (エンドユーザー)"\n                            :data-type   "datetime"\n                            :type        :foreigner)</code></pre> </div> </div> </div> </section> </div> </section> <section class="section"> <div class="container"> <h1 class="title is-5">Entity へ Attribute を追加する。</h1> <h2 class="subtitle"></h2> <div class="contents"> <pre><code>(tx-add-attribute-2-entity ter.db:*graph*\n                           :campus-code :rbp\n                           :entity-code :user\n                           :code        :image\n                           :name        "更新日時 (エンドユーザー)"\n                           :data-type   "datetime")</code></pre> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('function_tx-add-attribute-2-entity', '<section class="section"> <div class="container"> <h1 class="title"> <i style="font-weight:normal; font-size:14px;">Function</i> <b>tx-add-attribute-2-entity</b> </h1> <h2 class="subtitle"> <subtitle-breadcrumb></subtitle-breadcrumb> </h2> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Syntax:</h1> <div class="contents"> </div> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Arguments and Values:</h1> <h2 class="subtitle"></h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Description:</h1> <h2 class="subtitle"></h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Examples:</h1> <h2 class="subtitle"></h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">See Also:</h1> <h2 class="subtitle">None.</h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Notes:</h1> <h2 class="subtitle">None.</h2> </div> </section> </div> </section>', '', '', function(opts) {
});

riot.tag2('function_tx-add-identifier-2-entity', '<section class="section"> <div class="container"> <h1 class="title"> <i style="font-weight:normal; font-size:14px;">Function</i> <b>tx-add-identifier-2-entity</b> </h1> <h2 class="subtitle"> <subtitle-breadcrumb></subtitle-breadcrumb> </h2> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Syntax:</h1> <div class="contents"> </div> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Arguments and Values:</h1> <h2 class="subtitle"></h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Description:</h1> <h2 class="subtitle"></h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Examples:</h1> <h2 class="subtitle"></h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">See Also:</h1> <h2 class="subtitle">None.</h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Notes:</h1> <h2 class="subtitle">None.</h2> </div> </section> </div> </section>', '', '', function(opts) {
});

riot.tag2('generic-function_tx-make-relationship', '<section class="section"> <div class="container"> <h1 class="title"> <i style="font-weight:normal; font-size:14px;">Standard Generic Function</i> <b>tx-make-relationship</b> </h1> <h2 class="subtitle"> <subtitle-breadcrumb></subtitle-breadcrumb> </h2> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Syntax:</h1> <div class="contents"> <p style="padding:22px 22px; background:#eeeeee; border-radius:3px; font-size:33px;"> <i style="color:#888;">tx-make-relationship</i> <b>graph</b> <b>from</b> <b>to</b> <i style="color:#888;">&key</i> <b>type</b> </p> </div> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Method Signatures:</h1> <div class="contents"> <table class="table is-bordered is-striped is-narrow is-hoverable"> <thead><tr><th>graph</th><th>from</th><th>to</th></tr></thead> <tbody> <tr> <td>t</td> <td>RESOURCE</td> <td>RESOURCE</td> </tr> <tr> <td>t</td> <td>RESOURCE</td> <td>EVENT</td> </tr> <tr> <td>t</td> <td>EVENT</td> <td>EVENT</td> </tr> <tr> <td>t</td> <td>IDENTIFIER-INSTANCE</td> <td>IDENTIFIER-INSTANCE</td> </tr> <tr> <td>t</td> <td>t</td> <td>t</td> </tr> </tbody> </table> </div> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Arguments and Values:</h1> <h2 class="subtitle"></h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Description:</h1> <h2 class="subtitle"></h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Examples:</h1> <h2 class="subtitle"></h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Side Effects:</h1> <h2 class="subtitle">None.</h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Affected By:</h1> <h2 class="subtitle">None.</h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Exceptional Situations:</h1> <h2 class="subtitle">None.</h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">See Also:</h1> <h2 class="subtitle">None.</h2> </div> </section> <section class="section clhs-section"> <div class="container"> <h1 class="title is-5">Notes:</h1> <h2 class="subtitle">None.</h2> </div> </section> </div> </section>', 'generic-function_tx-make-relationship .clhs-section { padding-top: 11px; } generic-function_tx-make-relationship .clhs-section > .container > .contents { padding-left: 22px; }', '', function(opts) {
});

riot.tag2('home', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('home_page_root', '<section-header title="TER Docs"></section-header> <section class="section"> <div class="container"> <h1 class="title">CDN</h1> <h2 class="subtitle"></h2> <div class="contents"> <table class="table is-bordered is-striped is-narrow is-hoverable"> <thead> <tr> <th>Version</th> <th>Url</th> <th>Description</th> </tr> </thead> <tbody> <tr each="{rec in cdn}"> <td>{rec.version}</td> <td><a href="{rec.url}">{rec.url}</a></td> <td>{rec.description}</td> </tr> </tbody> </table> </div> </div> </section>', '', '', function(opts) {
     this.cdn = [
         { version: 'beta',  description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/Er.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/Er.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/ErEdge.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/ErPort.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/ErTable.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/ErTableColumn.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/Ter.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/TerAttribute.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/TerEdge.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/TerEntity.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/TerIdentifier.js' },
         { version: 'beta', description: '', url: 'https://yanqirenshi.github.io/TER/dist/beta/TerPort.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/Er.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/ErEdge.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/ErPort.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/ErTable.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/ErTableColumn.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/Ter.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/TerAttribute.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/TerEdge.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/TerEntity.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/TerIdentifier.js' },
         { version: '0.0.2', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.2/TerPort.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/Er.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/ErEdge.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/ErPort.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/ErTable.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/ErTableColumn.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/Ter.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/TerAttribute.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/TerEdge.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/TerEntity.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/TerIdentifier.js' },
         { version: '0.0.1', description: '', url: 'https://yanqirenshi.github.io/TER/dist/0.0.1/TerPort.js' },
     ];
});

riot.tag2('web', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('web_page_er', '<section-header title="[TER:WEB] ER"></section-header> <section-footer></section-footer>', '', '', function(opts) {
});

riot.tag2('web_page_root', '<section-header title="TER: WEB"></section-header> <section-footer></section-footer>', '', '', function(opts) {
});

riot.tag2('web_page_ter', '<section-header title="T字形ER図"></section-header> <page-tabs core="{page_tabs}" callback="{clickTab}"></page-tabs> <div> <web_page_ter_tab_home class="hide"></web_page_ter_tab_home> <web_page_ter_tab_entity class="hide"></web_page_ter_tab_entity> <web_page_ter_tab_identifier class="hide"></web_page_ter_tab_identifier> <web_page_ter_tab_attribute class="hide"></web_page_ter_tab_attribute> <web_page_ter_tab_port class="hide"></web_page_ter_tab_port> <web_page_ter_tab_relationship class="hide"></web_page_ter_tab_relationship> </div> <section-footer></section-footer>', '', '', function(opts) {
     this.page_tabs = new PageTabs([
         {code: 'home',         label: 'Home',         tag: 'web_page_ter_tab_home' },
         {code: 'enity',        label: 'Enity',        tag: 'web_page_ter_tab_entity' },
         {code: 'identifier',   label: 'Identifier',   tag: 'web_page_ter_tab_identifier' },
         {code: 'attribute',    label: 'Attribute',    tag: 'web_page_ter_tab_attribute' },
         {code: 'port',         label: 'Port',         tag: 'web_page_ter_tab_port' },
         {code: 'Relationship', label: 'Relationship', tag: 'web_page_ter_tab_relationship' },
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

riot.tag2('web_page_ter_tab_attribute', '<section class="section"> <div class="container"> <h1 class="title"></h1> <h2 class="subtitle"></h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('web_page_ter_tab_entity', '<section class="section"> <div class="container"> <h1 class="title">Data</h1> <h2 class="subtitle"></h2> <div class="contents"> <p>Data は連想配列です。</p> <p>Data のキーは以下の通りです。</p> <table class="table"> <thead><tr><th>Key</th><th>Description</th></tr></thead> <tbody> <tr> <td>_id</td> <td></td> </tr> <tr> <td>_class</td> <td></td> </tr> <tr> <td>code</td> <td></td> </tr> <tr> <td>name</td> <td></td> </tr> <tr> <td>position</td> <td></td> </tr> <tr> <td>size</td> <td></td> </tr> </tbody> </table> </div> <section class="section"> <div class="container"> <h1 class="title">_class</h1> <div class="container"> <p>String</p> <table class="table"> <tbody> <tr> <th>RESOURCE</th> <td>リソース</td> </tr> <tr> <th>EVENT</th> <td>イベント</td> </tr> <tr> <th>COMPARATIVE</th> <td>対照表</td> </tr> <tr> <th>CORRESPONDENCE</th> <td>対応表</td> </tr> <tr> <th>RECURSION</th> <td>再帰</td> </tr> </tbody> </table> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title">code</h1> <div class="container"> <p>String</p> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title">name</h1> <div class="container"> <p>String</p> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title">position</h1> <div class="container"> <p>連想配列</p> <table class="table"> <thead><tr><th>Key</th><th>Description</th></tr></thead> <tbody> <tr> <th>x</th> <td></td> </tr> <tr> <th>y</th> <td></td> </tr> </tbody> </table> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title">size</h1> <div class="container"> <p>連想配列</p> <table class="table"> <thead><tr><th>Key</th><th>Description</th></tr></thead> <tbody> <tr> <th>w</th> <td></td> </tr> <tr> <th>h</th> <td></td> </tr> </tbody> </table> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title">_id</h1> </div> <div class="container"> <p>Integer</p> </div> </section> </div> </section>', '', '', function(opts) {
});

riot.tag2('web_page_ter_tab_home', '<section class="section"> <div class="container"> <h1 class="title">Usage</h1> <h2 class="subtitle"></h2> <div class="contents"> <p> <pre><code>\nlet d3svg = makeD3Svg();\nlet svg = d3svg.Svg();\nlet forground = svg.selectAll(\'g.base.forground\');\n\nnew Entity()\n    .data(state)\n    .sizing()\n    .positioning()\n    .draw(forground);</code></pre> </p> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title">State</h1> <h2 class="subtitle"></h2> <div class="contents"> <p>Data は連想配列です。</p> <p>Data のキーは以下の通りです。</p> <table class="table"> <thead><tr><th>Key</th><th>Description</th></tr></thead> <tbody> <tr> <td>entities</td> <td></td> </tr> <tr> <td>identifier_instances</td> <td></td> </tr> <tr> <td>attribute_instances</td> <td></td> </tr> <tr> <td>ports</td> <td></td> </tr> <tr> <td>relationships</td> <td></td> </tr> </tbody> </table> </div> </div> </section> <section class="section"> <div class="container"> <h1 class="title">Class: Entity</h1> <section class="section"> <div class="container"> <h1 class="title">Methos</h1> <div class="contents"> <table class="table"> <thead><tr><th>Key</th><th>Description</th></tr></thead> <tbody> <tr> <td>data</td> <td></td> </tr> <tr> <td>sizing</td> <td></td> </tr> <tr> <td>positioning</td> <td></td> </tr> <tr> <td>draw</td> <td></td> </tr> </tbody> </table> </div> </div> </section> </div> </section>', '', '', function(opts) {
});

riot.tag2('web_page_ter_tab_identifier', '<section class="section"> <div class="container"> <h1 class="title"></h1> <h2 class="subtitle"></h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('web_page_ter_tab_port', '<section class="section"> <div class="container"> <h1 class="title"></h1> <h2 class="subtitle"></h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('web_page_ter_tab_relationship', '', '', '', function(opts) {
});
