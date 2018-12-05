<inspector-table-description>
    <div class="contents">
        <markdown-preview  data={marked(description())}></markdown-preview>
    </div>

    <div style="margin-top:11px;">
        <button class="button is-danger" onclick={clickSave}>Edit</button>
    </div>

    <script>
     this.description = () => {
         if (!opts.data) return '';

         return opts.data.description;
     };
    </script>

    <script>
     this.clickSave = () => {
         let table = this.opts.data;

         this.opts.callback('edit-table-description', table);
     };
    </script>
</inspector-table-description>
