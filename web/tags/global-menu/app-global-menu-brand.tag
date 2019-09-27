<app-global-menu-brand>

    <div onclick={clickBrand}>
        {opts.source ? opts.source.label : 'TER'}
    </div>

    <script>
     this.clickBrand = () => {
         ACTIONS.openModalChooseSystem();
     };
    </script>

    <style>
     app-global-menu-brand {
         display: flex;
         justify-content: center;
         align-items: center;

         width: 111px;
         height: 111px;

         font-weight: bold;
     }
     app-global-menu-brand > div {
         width: 66px;
         height: 66px;

         color: #fff;
         background: #CF2317;
         border-radius: 5px;

         display: flex;
         justify-content: center;
         align-items: center;
     }
    </style>

</app-global-menu-brand>
