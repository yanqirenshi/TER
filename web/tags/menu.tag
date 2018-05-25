<menu>
    <div class="menu-item {active('ER')}"    code="ER"    onclick={click}>ER</div>
    <div class="menu-item {active('TER')}"   code="TER"   onclick={click}>TER</div>
    <div class="menu-item {active('GRAPH')}" code="GRAPH" onclick={click}>Graph</div>

    <style>
     menu > .menu-item {
         float: right;
         margin-left: 11px;
         border-radius: 55px;
         width: 55px;
         height: 55px;
         background: #eeeeee;
         z-index: 99999999;
         opacity: 0.9;

         text-align: center;
         padding-top: 15px
     }
     menu > .menu-item.active {
         background: rgba(236, 109, 113, 0.8);
     }
    </style>

    <script>
     this.active = (code) => {
         let page = this.opts.data[code];

         return page.active ? 'active' : '';
     };
     this.click = (e) => {
         let target = e.target;
         let hash = '#' + target.getAttribute('CODE');

         if (hash!=location.hash)
             location.hash = hash;
     };
    </script>
</menu>
