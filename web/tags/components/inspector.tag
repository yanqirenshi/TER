<inspector>
    <div class={hide()}>
        <inspector-table class={hideContents('table')} data={this.data()}></inspector-table>
        <inspector-column class={hideContents('column-instance')} data={this.data()}></inspector-column>
    </div>

    <style>
     inspector > div {
         overflow-y: auto;
         min-width: 333px;
         height: 100vh;
         position: fixed;
         right: 0px;
         top: 0px;
         background: #fff;
         box-shadow: 0px 0px 8px #888;
         padding: 22px;
     }
     inspector > div.hide {
         display: none;
     }
    </style>

    <script>
     this.state = () => { return STORE.state().get('inspector'); } ;
     this.data = () => {
         return this.state().data;
     };
     this.hideContents = (type) => {
         let data = this.data();
         if (!data) return 'hide';
         return data._class == type.toUpperCase() ? '' : 'hide';
     };
     this.hide = () => {
         return this.state().display ? '' : 'hide';
     };
     STORE.subscribe ((action) => {
         if (action.type=='SET-DATA-TO-INSPECTOR')
             this.update();
     })
    </script>
</inspector>
