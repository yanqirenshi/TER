<page-usage-base>
    <section-header title="TER: Core"></section-header>

    <page-tabs core={page_tabs} callback={clickTab}></page-tabs>

    <div>
        <page-core_tab-readme  class="hide"></page-core_tab-readme>
        <page-core_tab-modeler  class="hide"></page-core_tab-modeler>
        <page-usage_tab-system  class="hide"></page-usage_tab-system>
        <page-usage_tab-schema  class="hide"></page-usage_tab-schema>
        <page-core_tab-campus   class="hide"></page-core_tab-campus>
        <page-core_tab-camera   class="hide"></page-core_tab-camera>
        <page-core_tab-assembly class="hide"></page-core_tab-assembly>
    </div>

    <section-footer></section-footer>

    <script>
     this.page_tabs = new PageTabs([
         {code: 'readme',   label: 'Readme',      tag: 'page-core_tab-readme' },
         {code: 'modeler',  label: 'Modeler',     tag: 'page-core_tab-modeler' },
         {code: 'system',   label: 'System',      tag: 'page-usage_tab-system' },
         {code: 'schema',   label: 'Schema',      tag: 'page-usage_tab-schema' },
         {code: 'campus',   label: 'Campus',      tag: 'page-core_tab-campus' },
         {code: 'camera',   label: 'Camera',      tag: 'page-core_tab-camera' },
         {code: 'assembly', label: 'Base の組立', tag: 'page-core_tab-assembly' },
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
     page-usage-base > page-tabs {
         display: block;
         margin-top:22px;
     }
    </style>

</page-usage-base>
