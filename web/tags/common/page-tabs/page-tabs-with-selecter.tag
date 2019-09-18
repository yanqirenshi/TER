<page-tabs-with-selecter>

    <div class="tabs is-boxed">
        <ul>
            <li style="margin-right:11px;">
                <div class="select">
                    <select>
                        <option each={obj in opts.source}
                                selected={isSelect(obj)}>
                            {obj.code + ": " + obj.name}
                        </option>
                    </select>
                </div>
            </li>

            <li each={opts.core.tabs}
                class="{opts.core.active_tab==code ? 'is-active' : ''}">
                <a code={code}
                   onclick={clickTab}>{label}</a>
            </li>
        </ul>
    </div>

    <script>
     this.isSelect = (obj) => {
         let active = opts.active;

         return obj._id==active._id;
     };
    </script>

    <script>
     this.clickTab = (e) => {
         let code = e.target.getAttribute('code');
         this.opts.callback(e, 'CLICK-TAB', { code: code });
     };
    </script>

    <style>
     page-tabs-with-selecter li:first-child {
         margin-left: 11px;
     }
     page-tabs-with-selecter .select select {
         border: none;
     }
    </style>
</page-tabs-with-selecter>
