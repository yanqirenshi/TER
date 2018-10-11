<page-tabs>
    <div class="tabs is-boxed" style="padding-left:55px;">
        <ul>
            <li each={opts.core.tabs}
                class="{opts.core.active_tab==code ? 'is-active' : ''}">
                <a code={code}
                   onclick={clickTab}>{label}</a>
            </li>
        </ul>
    </div>

    <style>
     page-tabs li:first-child { margin-left: 55px; }
    </style>

    <script>
     this.clickTab = (e) => {
         let code = e.target.getAttribute('code');
         this.opts.callback(e, 'CLICK-TAB', { code: code });
     };
    </script>
</page-tabs>
