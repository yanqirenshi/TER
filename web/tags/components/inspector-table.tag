<inspector-table>
    <h1 class="title is-4" style="margin-bottom: 8px;">Table</h1>

    <div class="tabs">
        <ul>
            <li class="{isActive('basic')}">
                <a code="basic" onclick={clickTab}>Basic</a>
            </li>
            <li class="{isActive('description')}">
                <a code="description" onclick={clickTab}>Description</a>
            </li>
            <li class="{isActive('relationship')}">
                <a code="relationship" onclick={clickTab}>Relationship</a>
            </li>
        </ul>
    </div>

    <inspector-table-basic class="{isHide('basic')}"
                           name={getVal('name')}
                           columns={getVal('_column_instances')}></inspector-table-basic>

    <inspector-table-description class="{isHide('description')}"
                                 description={getVal('description')}></inspector-table-description>

    <inspector-table-relationship class="{isHide('relationship')}"
                                  data={data()}></inspector-table-relationship>

    <style>
     inspector-table .hide { display: none; }
    </style>

    <style>
     inspector-table .section {
         padding: 11px;
         padding-top: 0px;
     }

     inspector-table section-contents .section {
         padding-bottom: 0px;
         padding-top: 0px;
     }

     inspector-table .contents, inspector-table .container {
         width: auto;
     }
    </style>


    <script>
     this.data = () => {
         return this.opts.data;
     };
     this.getVal = (name) => {
         let data = this.opts.data;

         if (!data || !data[name]) return '';

         if (name!='_column_instances')
             return data[name];
         else
             return data[name].sort((a,b)=>{ return (a._id*1) - (b._id*1); });
     };

     this.active_tab = 'basic'
     this.isActive = (code) => {
         return code == this.active_tab ? 'is-active' : '';
     };
     this.isHide = (code) => {
         return code != this.active_tab ? 'hide' : '';
     };
     this.clickTab = (e) => {
         this.active_tab = e.target.getAttribute('code');
         this.update();
     };
    </script>
</inspector-table>
