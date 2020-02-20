<inspector-table-basic>
    <section-container no="5" title="Name" name={opts.name}>
        <section-contents name={opts.name}>
            <p>{opts.name}</p>
        </section-contents>
    </section-container>

    <section-container no="5" title="Columns" columns={opts.columns}>
        <section-contents columns={opts.columns}>
            <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth ter-table">
                <thead>
                    <tr> <th>物理名</th> <th>論理名</th> <th>タイプ</th></tr>
                </thead>
                <tbody>
                    <tr each={opts.columns}>
                        <td>{physical_name}</td>
                        <td>{logical_name}</td>
                        <td>{data_type}</td>
                    </tr>
                </tbody>
            </table>
        </section-contents>
    </section-container>
</inspector-table-basic>
