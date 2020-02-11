<modal-choose-system-list>

    <button class="button"
            each={obj in opts.source}
            system-id={obj._id}
            onclick={clickItem}>
        {obj.code} : {obj.name}
    </button>

    <script>
     this.clickItem = (e) => {
         let id = e.target.getAttribute('system-id')  * 1;

         this.opts.callback('select-item', id)
     };
    </script>

    <style>
     modal-choose-system-list {
         display: block;
     }
     modal-choose-system-list > .button {
         float: left;
         margin-left: 11px;
         margin-bottom: 11px;
     }
    </style>

</modal-choose-system-list>
