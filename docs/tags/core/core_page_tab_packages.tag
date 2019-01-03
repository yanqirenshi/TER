<core_page_tab_packages>
    <section class="section">
        <div class="container">
            <h1 class="title is-4">List</h1>
            <h2 class="subtitle"></h2>
            <div class="contents">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr each={packages}>
                            <td>
                                <a href={'#core/pakages/'+name}>
                                    {name.toUpperCase()}
                                </a>
                            </td>
                            <td>{description}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>


    <script>
     this.packages = [
         { code: 'ter',        name: 'ter',        description: '' },
         { code: 'ter.parser', name: 'ter.parser', description: '' },
         { code: 'ter.db',     name: 'ter.db',     description: '' },
         { code: 'ter-test',   name: 'ter-test',   description: '' },
     ]

    </script>
</core_page_tab_packages>
