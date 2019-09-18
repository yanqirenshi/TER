<page-tabs-with-selecter>

    <div class="tabs is-boxed">
        <ul>
            <li style="margin-right:11px;">
                <div class="select">
                    <select>
                        <option>Select dropdown</option>
                        <option>With options</option>
                        <option>With options</option>
                        <option>With options</option>
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

    <style>
     page-tabs-with-selecter li:first-child {
         margin-left: 11px;
     }
     page-tabs-with-selecter .select select {
         border: none;
     }
    </style>

    <script>
     this.clickTab = (e) => {
         let code = e.target.getAttribute('code');
         this.opts.callback(e, 'CLICK-TAB', { code: code });
     };
    </script>
</page-tabs-with-selecter>
