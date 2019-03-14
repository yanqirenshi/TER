<operators>
    <div>
        <a each={opts.data}
           class="button {color}"
           code="{code}"
           onclick={click}>
            {name}
        </a>

    </div>

    <style>
     operators > div {
         position: fixed;
         right: 11px;
         bottom: 11px;
     }
     operators .button {
         display: block;
         margin-top: 11px;
     }
    </style>

    <script>
     this.click = (e) => {
         this.opts.callbak(e.target.getAttribute('code'), e);
     };
    </script>
</operators>
