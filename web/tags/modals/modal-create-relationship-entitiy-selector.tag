<modal-create-relationship-entitiy-selector>

    <div style="margin-bottom:8px;">
        <h1 class="title is-5">{opts.position==='from' ? 'From' : 'To'}</h1>
    </div>

    <div class="item-selected">
        <p>{selectedItem()}</p>
    </div>

    <div style="display:flex;">
        <div style="flex-grow:1;">
            <input class="input is-small"
                   type="text"
                   placeholder="Search"
                   ref="name"
                   onkeyup={changeSearchKeyword}>
        </div>
    </div>

    <div style="height: 333px;overflow: auto;">
        <div each={entity in list()}
             class="item"
             onclick={clickItem}
             entity-id={entity._id}>
            <p entity-id={entity._id}>{entity._class}</p>
            <p entity-id={entity._id}>{entity.code}</p>
            <p entity-id={entity._id}>{entity.name}</p>
        </div>
    </div>

    <script>
     this.state = {
         search: null,
     }
     this.clickItem = (e) => {
         let entity_id = e.target.getAttribute('entity-id') * 1;

         let entity = STORE.get('ter.entities.list').find((entity) => {
             return entity._id === entity_id;
         });

         this.opts.callback('change-entity', { position: opts.position, entity: entity });
     };
     this.changeSearchKeyword = (e) => {
         let val = e.target.value;

         this.state.search = val;

         this.update();
     };
     this.selectedItem = () => {
         let opts = this.opts;
         let entity = opts.source[opts.position];

         if (!entity)
             return 'Please Select';

         return entity._class + '\n' + entity.code + '\n' + entity.name;
     };
     this.list = () => {
         let list = STORE.get('ter.entities.list');

         let search_keyword = this.state.search;

         let out;
         if (!search_keyword) {
             out = list;
         } else {
             search_keyword = search_keyword.toUpperCase();
             out = list.filter((entity) => {
                 let str = (entity.code + entity.name).toUpperCase();

                 return str.indexOf(search_keyword) !== -1 ||
                        str.indexOf(search_keyword) !== -1;
             });
         }

         return out.sort((a, b) => {
             return a.code < b.code ? -1 : 1;
         });
     };
    </script>

    <style>
     modal-create-relationship-entitiy-selector .item {
         font-size:12px;
         margin-bottom:8px;
         margin-bottom: 8px;
         border: 1px solid #eee;
         border-radius: 3px;
         padding: 3px 6px;
     }
     modal-create-relationship-entitiy-selector .item-selected {
         font-size: 12px;
         margin-bottom:8px;
         background:#eee;
         border-radius:3px;
         padding: 3px 6px;
     }
    </style>

</modal-create-relationship-entitiy-selector>
