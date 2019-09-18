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

    <div class="move-page-menu {movePanelHide()}" ref="move-panel">
        <menu-bar-popup source={opts.moves}
                        callback={childrenCallback()}></menu-bar-popup>
    </div>

    <script>
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
    </script>

    <style>
     menu-bar .move-page-menu {
         z-index: 666665;
         background: rgba(255,255,255,1);
         position: fixed;
         left: 55px;
         top: 0px;
         min-width: 111px;
         height: 100vh;
         box-shadow: 2px 0px 8px 0px #e0e0e0;
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
         background: rgba(44, 169, 225, 0.8);
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

         font-size: 12px;
         font-weight: bold;

         padding-top: 7px;

     }
     .menu-label {
         background: rgba(255,255,255,1);
         color: rgba(44, 169, 225, 0.8);
     }
     .menu-label.open {
         background: rgba(255,255,255,1);
         color: rgba(44, 169, 225, 0.8);
         width: 45px;
         border-radius: 3px 0px 0px 3px;
         text-shadow: 0px 0px 1px #eee;
         padding-right: 11px;
     }
     menu-bar .menu-list a.is-active {
         width: 45px;
         padding-right: 11px;
         border-radius: 3px 0px 0px 3px;
         background: #ffffff;
         color: #333333;
     }
    </style>

</menu-bar>
