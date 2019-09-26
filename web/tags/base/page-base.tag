<page-base>

    <div style="padding-top: 22px;">
        <page-tabs core={page_tabs} callback={clickTab}></page-tabs>
    </div>

    <div class="tabs">
        <page-base_tabs-systems  class="hide"></page-base_tabs-systems>
        <page-base_tabs-modelers class="hide"></page-base_tabs-modelers>
    </div>


    <script>
     this.page_tabs = new PageTabs([
         { code: 'systems',  label: 'Systems',  tag: 'page-base_tabs-systems' },
         { code: 'modelers', label: 'Modelers', tag: 'page-base_tabs-modelers' },
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
     page-base {
         display: block;
         width: 100vw;
         height: 100vh;

         padding-left: 111px;
     }
     page-base page-tabs li:first-child {
         margin-left: 88px;
     }
    </style>

</page-base>
