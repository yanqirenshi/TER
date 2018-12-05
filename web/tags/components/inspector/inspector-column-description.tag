<inspector-column-description>
    <section class="section">
        <div class="container">
            <h1 class="title is-5">Description</h1>
            <h2 class="subtitle"></h2>
            <div class="contents" style="padding-left:22px; padding-top: 8px;">
                <textarea class="textarea"
                          placeholder="Description"
                          style="height:333px;"
                          ref="description"
                >{description()}</textarea>
            </div>
        </div>
    </section>

    <section class="section" style="margin-top: 11px;">
        <div class="container">
            <div class="contents" style="padding-left:22px;">
                <button class="button is-danger" onclick={clickSaveDescription}>Save</button>
            </div>
        </div>
    </section>

    <script>
     this.description = () => {
         if (!this.opts.source) return '';

         return this.opts.source.description;
     };
     this.clickSaveDescription = () => {
         opts.callback('click-save-column-description', {
             schema_code: STORE.get('schemas.active'),
             source: this.opts.source,
             description: this.refs.description.value
         });
     };
    </script>
</inspector-column-description>
