<web_page_ter>
    <section-header title="T字形ER図"></section-header>

    <page-tabs core={page_tabs} callback={clickTab}></page-tabs>

    <div>
        <web_page_ter_tab_home         class="hide"></web_page_ter_tab_home>
        <web_page_ter_tab_entity       class="hide"></web_page_ter_tab_entity>
        <web_page_ter_tab_identifier   class="hide"></web_page_ter_tab_identifier>
        <web_page_ter_tab_attribute    class="hide"></web_page_ter_tab_attribute>
        <web_page_ter_tab_port         class="hide"></web_page_ter_tab_port>
        <web_page_ter_tab_relationship class="hide"></web_page_ter_tab_relationship>
    </div>

    <section-footer></section-footer>

    <script>
     this.page_tabs = new PageTabs([
         {code: 'home',         label: 'Home',         tag: 'web_page_ter_tab_home' },
         {code: 'enity',        label: 'Enity',        tag: 'web_page_ter_tab_entity' },
         {code: 'identifier',   label: 'Identifier',   tag: 'web_page_ter_tab_identifier' },
         {code: 'attribute',    label: 'Attribute',    tag: 'web_page_ter_tab_attribute' },
         {code: 'port',         label: 'Port',         tag: 'web_page_ter_tab_port' },
         {code: 'Relationship', label: 'Relationship', tag: 'web_page_ter_tab_relationship' },
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
</web_page_ter>
