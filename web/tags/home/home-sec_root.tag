<home-sec_root>
    <div class="hero-body">
        <div class="container">
            <h1 class="title">Home</h1>
            <h2 class="subtitle"></h2>
        </div>
    </div>

    <page-tabs core={page_tabs} callback={clickTab}></page-tabs>

    <div class="tabs">
        <home-sec_root_tab-contents1 class="hide"></home-sec_root_tab-contents1>
        <home-sec_root_tab-ter class="hide"></home-sec_root_tab-ter>
        <home-sec_root_tab-er class="hide"></home-sec_root_tab-er>
    </div>

    <script>
     this.page_tabs = new PageTabs([
         {code: 'home', label: 'Home', tag: 'home-sec_root_tab-contents1' },
         {code: 'ter',  label: 'TER',  tag: 'home-sec_root_tab-ter' },
         {code: 'er',   label: 'ER',   tag: 'home-sec_root_tab-er' },
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
     home-sec_root {
         display: block;
         margin-left: 55px;
     }

     home-sec_root page-tabs li:first-child { margin-left: 8%; }
    </style>
</home-sec_root>
