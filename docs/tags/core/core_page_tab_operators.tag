<core_page_tab_operators>

    <section class="section">
        <div class="container">
            <h1 class="title">Dictionary</h1>
            <h2 class="subtitle"></h2>

            <div class="contents">
                <table class="table is-bordered is-striped is-narrow is-hoverable">
                    <thead>
                        <tr>
                            <th>Type</th>
                            <th>Name</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr each={operator in operators}>
                            <td>{operator.type}</td>
                            <td>
                                <a href={makeHref(operator.tag)}>
                                    {operator.name}
                                </a>
                            </td>
                            <td></td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </div>
    </section>

    <script>
     this.makeHref = (tag) => {
         return location.hash + '/' + tag;
     }
     this.operators = [
         { name: 'tx-make-relationship',       tag: 'tx-make-relationship',       type: 'Standard Generic Function' },
         { name: 'tx-add-identifier-2-entity', tag: 'tx-add-identifier-2-entity', type: 'Function' },
         { name: 'tx-add-attribute-2-entity',  tag: 'tx-add-attribute-2-entity',  type: 'Function' },
     ];
    </script>
</core_page_tab_operators>
