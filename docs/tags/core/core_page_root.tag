<core_page_root>
    <section-header title="TER: Core"></section-header>

    <page-tabs core={page_tabs} callback={clickTab}></page-tabs>

    <div>
        <core_page_tab_datamodels class="hide"></core_page_tab_datamodels>
        <core_page_tab_packages   class="hide"></core_page_tab_packages>
        <core_page_tab_classes    class="hide"></core_page_tab_classes>
        <core_page_tab_operators  class="hide"></core_page_tab_operators>
        <core_page_tab_readme     class="hide"></core_page_tab_readme>
    </div>

    <section-footer></section-footer>

    <script>
     this.page_tabs = new PageTabs([
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
    </script>

    <style>
     core_page_root > page-tabs {
         display: block;
         margin-top:22px;
     }
    </style>
</core_page_root>
