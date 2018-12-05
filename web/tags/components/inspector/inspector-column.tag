<inspector-column>
    <section class="section">
        <div class="container">
            <h1 class="title is-5">Column Instance</h1>
            <h2 class="subtitle" style="font-size: 0.8rem;">
                <span>{opts.source ? opts.source.physical_name : ''}</span>
                : 
                <span>{opts.source ? opts.source.logical_name : ''}</span>
            </h2>
        </div>
    </section>

    <page-tabs core={page_tabs} callback={clickTab}></page-tabs>

    <div style="margin-top:22px;">
        <inspector-column-basic       class="hide"
                                      source={opts.source}
                                      callback={opts.callback}></inspector-column-basic>
        <inspector-column-description class="hide"
                                      source={opts.source}
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
