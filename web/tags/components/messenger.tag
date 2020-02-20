<messenger>

    <div if={this.list().length<=1} style="height:36px; margin-bottom: 22px;">
    </div>

    <div if={this.list().length>1} style="margin-bottom: 22px;">
        <button class="button is-warning"
                style="width:100%;"
                action="normal"
                onclick={onClickClearAll}>
            Clear All
        </button>
    </div>

    <section>
        <messenger-article each={msg in list()}
                           source={msg}></messenger-article>
    </section>

    <script>
     this.list = () => { return STORE.get('ter.messages'); };
     this.onClickClearAll = () => {
         ACTIONS.closeAllMessage();
     };
     STORE.subscribe((action) => {
         if (action.type=='PUSH-MESSAGE') {
             this.update();
             return;
         }
         if (action.type=='CLOSE-MESSAGE' || action.type=='CLOSE-ALL-MESSAGE') {
             this.update();
             return;
         }
     });
    </script>

    <style>
     messenger {
         position: fixed;
         right: 22px;
         top: 22px;
         z-index: 9999999;
     }
    </style>

</messenger>
