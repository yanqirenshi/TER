<schema class="container">
    <div class="contents">
        <p>{name()}</p>
    </div>

    <style>
     schema.container {
         display: block;

         position: fixed;
         top: 11px;
         left: 11px;
         width: auto;

         padding: 8px;
         border-radius: 3px;

         color: #fff;
         background: rgba(44, 169, 225, 0.8);

         text-shadow: 0px 0px 3px #88888888;
         box-shadow: 0px 0px 3px #88888888;
     }
    </style>

    <script>
     this.name = ()=>{
         let schema = STORE.state().get('schema')
         return schema ? schema.name : '????????';
     };

     STORE.subscribe((action)=>{
         if (action.type=='FETCHED-SCHEMA')
             this.update();
     });
    </script>
</schema>
