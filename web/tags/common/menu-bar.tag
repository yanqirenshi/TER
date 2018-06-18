<menu-bar>
    <aside class="menu">
        <p ref="brand"
           class="menu-label"
           onclick={clickBrand}>
            {opts.brand.label}
        </p>
        <ul class="menu-list">
            <li each={opts.site.pages}>
                <a class="{opts.site.active_page==code ? 'is-active' : ''}"
                   href={'#' + code}>
                    {menu_label}
                </a>
            </li>
        </ul>
    </aside>

    <div class="move-page-menu hide" ref="move-panel">
        <p each={moves()}>
            <a href={href}>{label}</a>
        </p>
    </div>

    <style>
     menu-bar .move-page-menu {
         z-index: 666665;
         background: #fdeff2;
         position: fixed;
         left: 55px;
         top: 0px;
         min-width: 111px;
         height: 100vh;
         box-shadow: 2px 0px 8px 0px #e0e0e0;
         padding: 22px 55px 22px 22px;
     }
     menu-bar .move-page-menu.hide {
         display: none;
     }
     menu-bar .move-page-menu > p {
         margin-bottom: 11px;
     }
     menu-bar > .menu {
         z-index: 666666;
         height: 100vh;
         width: 55px;
         padding: 11px 0px 11px 11px;
         position: fixed;
         left: 0px;
         top: 0px;
         background: #e198b4;
     }

     menu-bar .menu-label, menu-bar .menu-list a {
         padding: 0;
         width: 33px;
         height: 33px;
         text-align: center;
         margin-top: 8px;
         border-radius: 3px;
         background: none;
         color: #ffffff;
         font-weight: bold;

         padding-top: 7px;
         font-size: 14px;

     }
     .menu-label {
         background: #fdeff2;
         color: #e198b4;
     }
     .menu-label.open {
         background: #fdeff2;
         color: #e198b4;
         width: 44px;
         border-radius: 3px 0px 0px 3px;
         text-shadow: 0px 0px 1px #eee;
         padding-right: 11px;
     }
     menu-bar .menu-list a.is-active {
         width: 44px;
         padding-right: 11px;
         border-radius: 3px 0px 0px 3px;
         background: #ffffff;
         color: #333333;
     }
    </style>

    <script>
     this.moves = () => {
         let moves = [
             { code: 'RBP',    href: '/rb/rbp/',    label: 'RBP: RUN PASSPORT' },
             { code: 'RBR',    href: '/rb/rbr/',    label: 'RBR: TATTA' },
             { code: 'GEMS',   href: '/rb/gems/',   label: 'Ruby Gems' },
             { code: 'RUBY',   href: '/rb/Ruby/',   label: 'Ruby' },
             { code: 'GITLAB', href: '/rb/gitlab/', label: 'Gitlab' },
             { code: 'SCRUM',  href: '/rb/Scrum/',  label: 'Scrum' },
             { code: 'HELP',   href: '/rb/help/',   label: 'Help' }
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
    </script>
</menu-bar>
