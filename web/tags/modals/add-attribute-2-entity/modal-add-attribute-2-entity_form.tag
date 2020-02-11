<modal-add-attribute-2-entity_form>

    <div>
        <h1 class="title is-4" style="margin-bottom: 8px;">New Attribute</h1>
        <div class="field">
            <label class="label">Code</label>
            <input class="input"
                   type="text"
                   placeholder="Code"
                   ref="code"
                   value={fieldVal('code')}
                   onkeyup={keyUp}>
        </div>

        <div class="field">
            <label class="label">Name</label>
            <input class="input"
                   type="text"
                   placeholder="Name"
                   ref="name"
                   value={opts.source.name}
                   onkeyup={keyUp}>
        </div>

        <div class="field">
            <label class="label">Data Type</label>
            <div class="select">
                <select ref="data_type"
                        onChange={changeVal}>
                    <option each={d in list()}
                            value={d.value}
                            selected={isSelected(d)}>
                        {d.label}
                    </option>
                </select>
            </div>
        </div>

        <div class="field">
            <label class="label">Description</label>
            <textarea class="textarea"
                      placeholder="Description"
                      ref="description"
                      value={opts.source.description}
                      onkeyup={keyUp}></textarea>
        </div>
    </div>

    <script>
     this.fieldVal = (code) => {
         let source = this.opts.source;

         return source[code];
     };
     this.isSelected = (d) => {
         let source = this.opts.source;

         return source.data_type === d.value;
     };
    </script>

    <script>
     this.keyUp = (e) => {
         let key = e.target.getAttribute('ref');
         let val = e.target.value;

         this.opts.callback ('change-data', {
             key: key,
             val: val,
         });
     };
     this.changeVal = (e) => {
         let key = e.target.getAttribute('ref');
         let val = e.target.value;

         if (val==='')
             val = null;

         this.opts.callback ('change-data', {
             key: key,
             val: val,
         });
     };
    </script>

    <script>
     this.list = () => [
         { label: 'Please Select', value: null },
         { label: 'STRING',        value: 'STRING' },
         { label: 'TEXT',          value: 'TEXT' },
         { label: 'INTEGER',       value: 'INTEGER' },
         { label: 'FLOAT',         value: 'FLOAT' },
         { label: 'TIMESTAMP',     value: 'TIMESTAMP' },
     ];
    </script>

    <style>
     modal-add-attribute-2-entity_form .field:not(:last-child) {
         margin-bottom: 0px;
     }
    </style>

</modal-add-attribute-2-entity_form>
