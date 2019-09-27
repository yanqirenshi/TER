<app-global-menu-item>

    <div class={isSelected()}>
        <a href={'#' + opts.source.code}>
            {opts.source.label}
        </a>
    </div>

    <script>
     this.isSelected = () => {
         if (this.opts.active_page_code == this.opts.source.code)
             return 'selected';

         return '';
     }
    </script>

    <style>
     app-global-menu-item {
         display: flex;
         justify-content: center;

         width: 100%;

         font-weight: bold;
     }
     app-global-menu-item > div {
         height: 33px;
         width: 88px;

         font-size: 12px;

         display: flex;
         align-items: center;
         justify-content: center;
     }
     app-global-menu-item > div.selected {
         background: #ffffff;
         height: 33px;
         width: 88px;

         width: 100%;
     }
     app-global-menu-item > div a {
         color: #CF2317;
     }
     app-global-menu-item > div a:hover {
         color: #CF2317;
     }
     app-global-menu-item > div.selected a {
         color: #CF2317;
     }
    </style>

</app-global-menu-item>
