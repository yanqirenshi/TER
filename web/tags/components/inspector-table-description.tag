<inspector-table-description>
    <div class="contents">
        <textarea class="textarea"
                  placeholder="Description"
                  style="height:333px;"
                  ref="description">{description()}</textarea>
    </div>

    <section class="section" style="margin-top: 11px;">
        <div class="container">
            <div class="contents">
                <button class="button is-danger" onclick={clickSave}>Save</button>
            </div>
        </div>
    </section>

    <script>
     this.description = () => {
         if (!opts.data) return '';

         return opts.data.description;
     };
    </script>

    <script>
     this.clickSave = () => {
         ACTIONS.saveTableDescription(
             STORE.get('schemas.active'),
             this.opts.data,
             this.refs['description'].value.trim());
     };
    </script>
</inspector-table-description>
