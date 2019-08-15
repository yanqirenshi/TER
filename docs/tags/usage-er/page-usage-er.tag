<page-usage-er>
    <section-header title="TER: Core"></section-header>

    <page-tabs core={page_tabs} callback={clickTab}></page-tabs>

    <div>
        <page-usage_tab-er      class="hide"></page-usage_tab-er>
    </div>

    <section-footer></section-footer>

    <script>
     this.page_tabs = new PageTabs([
         {code: 'er',       label: 'ER',          tag: 'page-usage_tab-er' },
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
     page-usage-er > page-tabs {
         display: block;
         margin-top:22px;
     }
    </style>

</page-usage-er>
