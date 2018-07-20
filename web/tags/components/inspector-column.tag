<inspector-column>
    <h1 class="title is-4">Column Instance</h1>

    <section-container no="5" title="Name"
                       physical_name={getVal('physical_name')}
                       logical_name={getVal('logical_name')}
                       callback={clickEditLogicalName}>
        <section-contents physical_name={opts.physical_name}
                          logical_name={opts.logical_name}
                          callback={opts.callback}>
            <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
                <tbody>
                    <tr> <th>物理名</th> <td>{opts.physical_name}</td></tr>
                    <tr> <th>論理名</th> <td>{opts.logical_name}</td></tr>
                </tbody>
            </table>
            <div style="text-align: right;">
                <button class="button" onclick={opts.callback}>論理名を変更</button>
            </div>
        </section-contents>
    </section-container>

    <section-container no="5" title="Type" val={getVal('data_type')}>
        <section-contents val={opts.val}>
            <p>{opts.val}</p>
        </section-contents>
    </section-container>

    <section-container no="5" title="Description" val={getVal('description')}>
        <section-contents val={opts.val}>
            <p>{opts.val}</p>
        </section-contents>
    </section-container>


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
     this.clickEditLogicalName = (e) => {
         if (this.opts.callback)
             this.opts.callback('click-edit-logical-name', this.opts.data);
     };
     this.getVal = (name) => {
         let data = this.opts.data;
         if (!data) return '';

         return data[name];
     };
     STORE.subscribe((action) => {
         if (action.type=='SAVED-COLUMN-INSTANCE-LOGICAL-NAME')
             this.update();
     });
    </script>
</inspector-column>
