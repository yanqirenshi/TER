<modal-create-relationship-type-selector>

    <div style="margin-bottom:8px;">
        <h1 class="title is-5">Type</h1>
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
        <div each={item in list()}
             class="item"
             onclick={clickItem}
             code={item.code}>
            <p code={item.code}>{item.name}</p>
            <p code={item.code}>
                {item.pattern.from + ' '}
                -
                {' ' + item.pattern.to}
            </p>
        </div>
    </div>

    <script>
     this.state = {
         search: null,
         list: [
             { code: 'COMPARATIVE',      name: '対照表',      pattern: {from: 'RESOURCE', to: 'RESOURCE'} },
             { code: 'RECURSION',        name: '再帰',        pattern: {from: 'RESOURCE', to: 'RESOURCE'} },
             { code: 'RESOURCE-SUBSET',  name: 'サブセット',  pattern: {from: 'RESOURCE', to: 'RESOURCE'} },
             { code: 'INJECT',           name: 'イベント',    pattern: {from: 'RESOURCE', to: 'EVENT'} },
             { code: 'CORRESPONDENCE',   name: '対応表',      pattern: {from: 'EVENT',    to: 'EVENT'} },
             { code: 'INJECT',           name: 'ヘッダ-明細', pattern: {from: 'EVENT',    to: 'EVENT'} },
             { code: 'EVENT-SUBSET',     name: 'サブセット',  pattern: {from: 'EVENT',    to: 'EVENT'} },
             { code: 'COMPARATIVE',      name: '対照表',      pattern: {from: 'EVENT',    to: 'RESOURCE'} },
         ],
         master: {
             'EVENT':           'EVENT',
             'EVENT-SUBSET':    'EVENT',
             'RESOURCE':        'RESOURCE',
             'RESOURCE-SUBSET': 'RESOURCE',
         }
     }
     this.clickItem = (e) => {
         let code = e.target.getAttribute('code');

         let item = this.state.list.find((item) => {
             return item.code === code;
         });
         this.opts.callback('change-type', item);
     };
     this.changeSearchKeyword = (e) => {
         let val = e.target.value;

         this.state.search = val;

         this.update();
     };
     this.selectedItem = () => {
         let item = this.opts.source.type;

         if (!item)
             return 'Please Select';

         return item.name + '\n' + item.pattern.from + ' - ' + item.pattern.to;
     };
     this.listFilter = (position, source, out) => {
         let entity = source[position];

         if (!entity)
             return out;

         let _class = this.state.master[entity._class];

         return out.filter((d) => {
             return d.pattern[position]===_class;
         }) ;
     }
     this.list = () => {
         let out = this.state.list;

         let source = this.opts.source;
         if (!source.from && !source.to)
             return [];

         out = this.listFilter('from', source, out);
         out = this.listFilter('to',   source, out);

         return out.sort((a, b) => {
             return a.code < b.code ? -1 : 1;
         });
     };
    </script>

    <style>
     modal-create-relationship-type-selector .item {
         font-size:12px;
         margin-bottom:8px;
         margin-bottom: 8px;
         border: 1px solid #eee;
         border-radius: 3px;
         padding: 3px 6px;
     }
     modal-create-relationship-type-selector .item-selected {
         font-size: 12px;
         margin-bottom:8px;
         background:#eee;
         border-radius:3px;
         padding: 3px 6px;
     }
    </style>

</modal-create-relationship-type-selector>
