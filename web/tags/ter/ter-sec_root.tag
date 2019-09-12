<ter-sec_root>

    <div style="margin-left:55px; padding-top: 22px;">
        <page-tabs core={page_tabs} callback={clickTab}></page-tabs>
    </div>

    <div class="tabs">
        <page-ter_tab-graph       class="hide"></page-ter_tab-graph>
        <page-ter_tab-entities    class="hide"></page-ter_tab-entities>
        <page-ter_tab-identifiers class="hide"></page-ter_tab-identifiers>
        <page-ter_tab-attributes  class="hide"></page-ter_tab-attributes>
    </div>

    <script>
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
    </script>

    <style>
     ter-sec_root page-tabs {
         display: flex;
         flex-direction: column;
     }

     ter-sec_root page-tabs li:first-child {
         margin-left: 88px;
     }
     ter-sec_root {
         display: flex;
         flex-direction: column;
         width: 100vw;
         height: 100vh;
     }
     ter-sec_root .tabs {
         flex-grow: 1;
     }
    </style>

</ter-sec_root>
