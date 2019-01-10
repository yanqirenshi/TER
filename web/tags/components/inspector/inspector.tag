<inspector>
    <div class={hide()}>
        <inspector-table class={hideContents('table')}
                         data={data()}
                         callback={opts.callback}></inspector-table>

        <inspector-column class={hideContents('column-instance')}
                          source={data()}
                          callback={opts.callback}></inspector-column>

        <inspector-entity class={hideContents('entity')}
                          source={data()}
                          callback={opts.callback}></inspector-entity>
    </div>

    <style>
     inspector > div {
         overflow-y: auto;
         min-width: 333px;
         max-width: 888px;
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

     inspector .section > .container > .contents { padding-left:22px;}
    </style>

    <script>
     this.state = () => { return STORE.state().get('inspector'); } ;
     this.data = () => {
         return this.state().data;
     };
     this.hideContents = (type) => {
         let data = this.data();

         if (!data)
             return 'hide';

         if (data._class == type.toUpperCase())
             return '';

         if (data._class=='RESOURCE' || data._class=='EVENT' || data._class=='COMPARATIVE')
             if (type=='entity')
                 return '';

         return 'hide';
     };
     this.hide = () => {
         return this.state().display ? '' : 'hide';
     };
     STORE.subscribe ((action) => {
         if (action.type=='SET-DATA-TO-INSPECTOR')
             this.update();

         if (action.type=='CLOSE-ALL-SUB-PANELS')
             this.update();
     })
    </script>
</inspector>
