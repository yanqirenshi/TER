<page-er>

    <div style="margin-left:55px; padding-top: 22px;">
        <page-tabs-with-selecter core={page_tabs}
                                 callback={clickTab}></page-tabs-with-selecter>
    </div>

    <div class="tabs">
        <page-er_tab-graph   class="hide"></page-er_tab-graph>
        <page-er_tab-tables  class="hide"></page-er_tab-tables>
        <page-er_tab-columns class="hide"></page-er_tab-columns>
    </div>

    <script>
     this.page_tabs = new PageTabs([
         { code: 'graph',   label: 'Graph',   tag: 'page-er_tab-graph' },
         { code: 'tables',  label: 'Tables',  tag: 'page-er_tab-tables' },
         { code: 'columns', label: 'Columns', tag: 'page-er_tab-columns' },
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
     page-er page-tabs-with-selecter {
         display: flex;
         flex-direction: column;
     }

     page-er page-tabs-with-selecter li:first-child {
         margin-left: 88px;
     }
     page-er {
         display: flex;
         flex-direction: column;
         width: 100vw;
         height: 100vh;
     }
     page-er .tabs {
         flex-grow: 1;
     }
    </style>

</page-er>
