<page-usage-ter>

    <section-header title="TER: Core"></section-header>

    <page-tabs core={page_tabs} callback={clickTab}></page-tabs>

    <div>
        <page-usage_tab-ter      class="hide"></page-usage_tab-ter>
    </div>

    <section-footer></section-footer>

    <script>
     this.page_tabs = new PageTabs([
         {code: 'er',       label: 'ER',          tag: 'page-usage_tab-ter' },
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
     page-usage-ter > page-tabs {
         display: block;
         margin-top:22px;
     }
    </style>

</page-usage-ter>
