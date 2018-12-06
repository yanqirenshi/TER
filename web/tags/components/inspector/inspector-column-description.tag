<inspector-column-description>
    <div>
        <markdown-preview  data={marked(description())}></markdown-preview>
    </div>

    <div style="margin-top:22px;">
        <button class="button is-danger" onclick={clickSaveDescription}>Edit</button>
    </div>

    <script>
     this.description = () => {
         if (!this.opts.source) return '';

         return this.opts.source.description;
     };
    </script>

    <script>
     this.clickSaveDescription = () => {
         let column_instance = this.opts.source;

         this.opts.callback('edit-column-instance-description', column_instance);
     };
    </script>
</inspector-column-description>
