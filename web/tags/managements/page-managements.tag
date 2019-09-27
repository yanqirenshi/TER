<page-managements>

    <div style="padding-top: 22px;">
        <page-tabs core={page_tabs} callback={clickTab}></page-tabs>
    </div>

    <div class="page-tabs">
        <page-managements_tabs-systems  class="hide" source={this.source}></page-managements_tabs-systems>
        <page-managements_tabs-modelers class="hide" source={this.source}></page-managements_tabs-modelers>
    </div>

    <script>
     this.source = {};
     STORE.subscribe((action)=>{
         if (action.type=='FETCHED-PAGES-MANAGEMENTS') {
             this.source = action.response;
             this.update();
             return;
         }
     });
     this.on('mount', () => {
         ACTIONS.fetchPagesManagements();
     });
    </script>


    <script>
     this.page_tabs = new PageTabs([
         { code: 'systems',  label: 'Systems',  tag: 'page-managements_tabs-systems' },
         { code: 'modelers', label: 'Modelers', tag: 'page-managements_tabs-modelers' },
     ]);

     this.on('mount', () => {
         this.page_tabs.switchTab(this.tags)
         this.update();
     });

     this.clickTab = (e, action, data) => {
         if (this.page_tabs.switchTab(this.tags, data.code))
             this.update();
     };
    </script>

    <style>
     page-managements {
         display: block;
         width: 100vw;
         height: 100vh;

         padding-left: 111px;
     }
     page-managements page-tabs li:first-child {
         margin-left: 88px;
     }
    </style>

</page-managements>
