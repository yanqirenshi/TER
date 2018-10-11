<page01_page_root>
    <section-header title="Page01"></section-header>

    <section-container title="セクション" data={sections()}>
        <sections-list data={opts.data}>
        </sections-list>
    </section-container>

    <section-footer></section-footer>

    <script>
     this.sections = () => {
         let pages = STORE.get('site').pages;
         let page = pages.find((d) => { return d.code=='page01'; });

         return page.sections;
     }
    </script>
</page01_page_root>
