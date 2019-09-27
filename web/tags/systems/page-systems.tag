<page-systems>

    <page-systems-granted   source={this.source}></page-systems-granted>

    <page-systems-ungranted source={this.source}></page-systems-ungranted>

    <script>
     this.source = {
         all: [],
         granted: {
             owner:  [],
             reader: [],
             editor: [],
         }
     };
     STORE.subscribe((action) => {
         if (action.type=='FETCHED-PAGES-SYSTEMS') {
             this.source = action.response;
             this.update();
             return;
         }
     });
     this.on('mount', () => {
         ACTIONS.fetchPagesSystems();
     });
    </script>

    <style>
     page-systems {
         display: block;
         width: 100vw;
     }
    </style>

</page-systems>
