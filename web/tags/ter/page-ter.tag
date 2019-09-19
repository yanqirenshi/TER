<page-ter>

    <div style="margin-left:55px; padding-top: 22px;">
        <page-tabs-with-selecter core={page_tabs}
                                 source={campuses()}
                                 active={activeCampus()}
                                 callback={clickTab}></page-tabs-with-selecter>
    </div>

    <div class="tabs">
        <page-ter_tab-graph       class="hide"></page-ter_tab-graph>
        <page-ter_tab-entities    class="hide"></page-ter_tab-entities>
        <page-ter_tab-identifiers class="hide"></page-ter_tab-identifiers>
        <page-ter_tab-attributes  class="hide"></page-ter_tab-attributes>
    </div>

    <script>
     this.campuses = () => {
         let system = STORE.get('active.system');

         return system ? system.campuses : [];
     }
     this.activeCampus = () => {
         return STORE.get('active.ter.campus');
     }
    </script>

    <script>
     STORE.subscribe(this, (action) => {
         if(action.type=='SAVED-TER-PORT-POSITION') {
             let state = STORE.get('ter');

             let port_id = action.target._id;
             let edges = state.relationships.indexes.to[port_id];
             let edge = null;
             for (let key in edges) {
                 let edge_tmp = edges[key];
                 if (edge_tmp.from_class=="IDENTIFIER-INSTANCE")
                     edge = edge_tmp;
             }

             this.painter.movePort(edge._from._entity, action.target);
         }

         if (action.type=='FETCHED-ENVIRONMENT') {
             this.startFirstLoadData();
             return;
         }

         if (action.mode=='FIRST') {

             if (action.type=='FETCHED-TER-ENVIRONMENT')
                 ACTIONS.fetchTerEntities(action.schema, action.mode);

             if (action.type=='FETCHED-TER-ENTITIES')
                 ACTIONS.fetchTerIdentifiers(action.schema, action.mode);

             if (action.type=='FETCHED-TER-IDENTIFIERS')
                 ACTIONS.fetchTerAttributes(action.schema, action.mode);

             if (action.type=='FETCHED-TER-ATTRIBUTES')
                 ACTIONS.fetchTerPorts(action.schema, action.mode);

             if (action.type=='FETCHED-TER-PORTS')
                 ACTIONS.fetchTerEdges(action.schema, action.mode);

             if(action.type=='FETCHED-TER-EDGES')
                 ACTIONS.fetchedAllDatas(action.mode);

             if(action.type=='FETCHED-ALL-DATAS') {
                 this.update();
             }
         }

         if (action.type=='CHANGE-SYSTEM') {
             this.startFirstLoadData();
             return;
         }
     });

     this.startFirstLoadData = () => {
         let active_campus = this.activeCampus();

         if (!active_campus)
             return;

         ACTIONS.fetchTerEnvironment(active_campus.code, 'FIRST');
     };
     this.on('mount', () => {
         this.startFirstLoadData();
     });
    </script>

    <script>
     this.page_tabs = new PageTabs([
         {code: 'graph',       label: 'Graph',       tag: 'page-ter_tab-graph' },
         {code: 'entities',    label: 'Entities',    tag: 'page-ter_tab-entities' },
         {code: 'identifiers', label: 'Identifiers', tag: 'page-ter_tab-identifiers' },
         {code: 'attributes',  label: 'Attributes',  tag: 'page-ter_tab-attributes' },
     ]);

     this.on('mount', () => {
         this.page_tabs.switchTab(this.tags)
         this.update();
     });

     this.clickTab = (e, action, data) => {
         if (this.page_tabs.switchTab(this.tags, data.code))
             this.update();
     };
    </script>

    <style>
     page-ter page-tabs-with-selecter {
         display: flex;
         flex-direction: column;
     }

     page-ter page-tabs-with-selecter li:first-child {
         margin-left: 88px;
     }
     page-ter {
         display: flex;
         flex-direction: column;
         width: 100vw;
         height: 100vh;
     }
     page-ter .tabs {
         flex-grow: 1;
     }
    </style>

</page-ter>
