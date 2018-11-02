<inspector-column-basic>
    <section class="section">
        <div class="container">
            <h1 class="title is-5">物理名</h1>
            <div class="contents">
                <p>{getVal('physical_name')}</p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-5">論理名</h1>
            <div class="contents">
                <p>{getVal('logical_name')}</p>

                <div style="text-align:right;">
                    <button class="button" onclick={clickEditLogicalName}>論理名を変更</button>
                </div>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-5">Type</h1>
            <div class="contents">
                <p>{getVal('data_type')}</p>
            </div>
        </div>
    </section>

    <script>
     this.clickEditLogicalName = (e) => {
         if (this.opts.callback)
             this.opts.callback('click-edit-logical-name', this.opts.source);
     };
     this.getVal = (name) => {
         let data = this.opts.source;
         if (!data) return 'なし';

         return data[name];
     };
    </script>
</inspector-column-basic>
