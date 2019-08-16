<page-usage-ter>

    <section-header title="TER: Core"></section-header>

    <page-tabs core={page_tabs} callback={clickTab}></page-tabs>

    <div>
        <page-usage_tab-overview             class="hide"></page-usage_tab-overview>
        <page-usage_tab-add-entity-basic     class="hide"></page-usage_tab-add-entity-basic>
        <page-usage_tab-add-attributes       class="hide"></page-usage_tab-add-attributes>
        <page-usage_tab-add-entity-subset    class="hide"></page-usage_tab-add-entity-subset>
        <page-usage_tab-add-entity-recursion class="hide"></page-usage_tab-add-entity-recursion>
        <page-usage_tab-add-entity-detail    class="hide"></page-usage_tab-add-entity-detail>
    </div>

    <section-footer></section-footer>

    <script>
     this.page_tabs = new PageTabs([
         {code: 'overview',         label: 'Overview',                 tag: 'page-usage_tab-overview' },
         {code: 'entity-basic',     label: 'エンティティ：基本',       tag: 'page-usage_tab-add-entity-basic' },
         {code: 'add-attributes',   label: 'エンティティ：属性',       tag: 'page-usage_tab-add-attributes' },
         {code: 'entity-subset',    label: 'エンティティ：サブセット', tag: 'page-usage_tab-add-entity-subset' },
         {code: 'entity-recursion', label: 'エンティティ：再帰',       tag: 'page-usage_tab-add-entity-recursion' },
         {code: 'entity-detail',    label: 'エンティティ：明細',       tag: 'page-usage_tab-add-entity-detail' },
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
