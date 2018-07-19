<page03-modal-logical-name>
    <div class="modal {isActive()}">
        <div class="modal-background"></div>
        <div class="modal-content">
            <nav class="panel">
                <p class="panel-heading">
                    論理名の変更
                </p>
                <div class="panel-block" style="background: #fff;">
                    <span style="margin-right:11px;">テーブル: </span>
                    <span>{tableName()}</span>
                </div>
                <div class="panel-block" style="background: #fff;">
                    <span style="margin-right:11px;">物理名:</span>
                    <span>{physicalName()}</span>
                </div>

                <div class="panel-block" style="background: #fff;">
                    <input class="input"
                           type="text"
                           value={opts.data.logical_name}
                           placeholder="論理名"
                           ref="logical_name">
                </div>
                <div class="panel-block" style="background: #fff;">
                    <button class="button is-danger is-fullwidth"
                            onclick={clickSaveButton}>
                        Save
                    </button>
                </div>
            </nav>
        </div>
        <button class="modal-close is-large"
                aria-label="close"
                onclick={clickCloseButton}></button>
    </div>

    <script>
     this.isActive = () => {
         return this.opts.data.data ? 'is-active' : '';
     };
     this.tableName = () => {
         if (!opts.data.data) return '???';

         let table = opts.data.data._table;

         return table.name;
     };
     this.physicalName = () => {
         dump(opts.data.data);
         if (opts.data.data)
             return opts.data.data.physical_name;

         return '???';
     };
     this.clickSaveButton = () => {
         this.opts.callback('click-save-button', this.refs.logical_name.value);
     };
     this.clickCloseButton = () => {
         this.opts.callback('click-close-button');
     };
    </script>
</page03-modal-logical-name>
