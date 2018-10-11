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

riot.tag2('home', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('home_page_root', '<section-header title="TER Docs"></section-header>', '', '', function(opts) {
});

riot.tag2('page01', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('page01_page1', '<section-header-with-breadcrumb title="Page01 Sec 1"></section-header-with-breadcrumb>', '', '', function(opts) {
});

riot.tag2('page01_page2', '<section-header-with-breadcrumb title="Page01 Sec 2"></section-header-with-breadcrumb>', '', '', function(opts) {
});

riot.tag2('page01_page3', '<section-header-with-breadcrumb title="Page01 Sec 3"></section-header-with-breadcrumb>', '', '', function(opts) {
});

riot.tag2('page01_page_root', '<section-header title="Page01"></section-header> <section-container title="セクション" data="{sections()}"> <sections-list data="{opts.data}"> </sections-list> </section-container> <section-footer></section-footer>', '', '', function(opts) {
     this.sections = () => {
         let pages = STORE.get('site').pages;
         let page = pages.find((d) => { return d.code=='page01'; });

         return page.sections;
     }
});

riot.tag2('page02', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('page02_page_root', '<section-header title="Page02"></section-header> <page-tabs core="{page_tabs}" callback="{clickTab}"></page-tabs> <div> <page02_page_tab_readme class="hide"></page02_page_tab_readme> <page02_page_tab_tab1 class="hide"></page02_page_tab_tab1> <page02_page_tab_tab2 class="hide"></page02_page_tab_tab2> <page02_page_tab_tab3 class="hide"></page02_page_tab_tab3> <page02_page_tab_help class="hide"></page02_page_tab_help> </div> <section-footer></section-footer>', '', '', function(opts) {
     this.page_tabs = new PageTabs([
         {code: 'readme', label: 'README', tag: 'page02_page_tab_readme' },
         {code: 'tab1',   label: 'TAB1',   tag: 'page02_page_tab_tab1' },
         {code: 'tab2',   label: 'TAB2',   tag: 'page02_page_tab_tab2' },
         {code: 'tab3',   label: 'TAB3',   tag: 'page02_page_tab_tab3' },
         {code: 'help',   label: 'HELP',   tag: 'page02_page_tab_help' },
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

riot.tag2('page02_page_tab_help', '<section class="section"> <div class="container"> <h1 class="title">HELP</h1> <h2 class="subtitle"> </h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('page02_page_tab_readme', '<section class="section"> <div class="container"> <h1 class="title">README</h1> <h2 class="subtitle"> </h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('page02_page_tab_tab1', '<section class="section"> <div class="container"> <h1 class="title">TAB1</h1> <h2 class="subtitle"> </h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('page02_page_tab_tab2', '<section class="section"> <div class="container"> <h1 class="title">TAB2</h1> <h2 class="subtitle"> </h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('page02_page_tab_tab3', '<section class="section"> <div class="container"> <h1 class="title">TAB3</h1> <h2 class="subtitle"> </h2> <div class="contents"> </div> </div> </section>', '', '', function(opts) {
});

riot.tag2('page03', '', '', '', function(opts) {
     this.mixin(MIXINS.page);

     this.on('mount', () => { this.draw(); });
     this.on('update', () => { this.draw(); });
});

riot.tag2('page03_page_root', '<section-header title="Page03"></section-header> <section-footer></section-footer>', '', '', function(opts) {
});
