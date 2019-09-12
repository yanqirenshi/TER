<home-sec_root>

    <script>
     this.on('mount', ()=>{
         ACTIONS.fetchPagesBasic();
     });
    </script>

    <script>
     this.source = {};
     STORE.subscribe((action)=>{
         if (action.type=='FETCHED-PAGES-BASIC') {
             this.source = action.response;
             this.update();
             return;
         }
     });
    </script>


    <style>
     home-sec_root {
         display: block;
         width: 100vw;
         height: 100vh;

         padding-left: 55px;
     }
    </style>

</home-sec_root>
