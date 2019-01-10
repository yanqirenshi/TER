<inspector-column>
    <section class="section">
        <div class="container">
            <h1 class="title is-5">Column Instance</h1>
            <h2 class="subtitle" style="font-size: 0.8rem;">
                <span>{physicalName()}</span>
                : 
                <span>{logicalName()}</span>
            </h2>
        </div>
    </section>

    <page-tabs core={page_tabs} callback={clickTab}></page-tabs>

    <div style="margin-top:22px;">
        <inspector-column-basic       class="hide"
                                      source={columnData()}
                                      callback={opts.callback}></inspector-column-basic>
        <inspector-column-description class="hide"
                                      source={columnData()}
                                      callback={opts.callback}></inspector-column-description>
    </div>

    <style>
     inspector-column .section {
         padding: 11px;
         padding-top: 0px;
     }

     inspector-column section-contents .section {
         padding-bottom: 0px;
         padding-top: 0px;
     }

     inspector-column .contents, inspector-column .container {
         width: auto;
     }
    </style>

    <script>
     this.columnData = () => {
         if (!opts.source)
             return null;
         if (opts.source._class!='COLUMN-INSTANCE')
             return null;
         return opts.source
     };
     this.physicalName = () => {
         let data = this.columnData();

         if (!data) return '';

         return data.physical_name;
     };
     this.logicalName = () => {
         let data = this.columnData();

         if (!data) return '';

         return data.logical_name;
     }
    </script>


    <script>
     this.page_tabs = new PageTabs([
         {code: 'basic',       label: 'Basic',       tag: 'inspector-column-basic' },
         {code: 'description', label: 'Description', tag: 'inspector-column-description' },
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

    <script>
     STORE.subscribe((action) => {
         if (action.type=='SAVED-COLUMN-INSTANCE-LOGICAL-NAME')
             this.update();
     });
    </script>
</inspector-column>
