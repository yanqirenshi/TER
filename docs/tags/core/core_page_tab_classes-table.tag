<core_page_tab_classes-table>
    <section class="section">
        <div class="container">
            <h1 class="title is-5">{opts.label}</h1>
            <h2 class="subtitle"></h2>
            <div class="contents">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Package</th>
                            <th>Name</th>
                            <th>Parent</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr each={rec in opts.data}>
                            <td>
                                <a href={"#core/packages/"+rec.package}>
                                    {rec.package.toUpperCase()}
                                </a>
                            </td>
                            <td>
                                <a href={"#core/classes/"+rec.name}>
                                    {rec.name.toUpperCase()}
                                </a>
                            </td>
                            <td>{rec.parent_classes}</td>
                            <td>{rec.file}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
</core_page_tab_classes-table>
