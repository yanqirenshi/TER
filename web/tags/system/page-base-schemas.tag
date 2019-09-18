<page-base-schemas>

    <section class="section">
        <div class="container">
            <h1 class="title">Schemas</h1>
            <h2 class="subtitle"></h2>

            <div each={obj in opts.source}>
                <div class="contetns" style="margin-left:22px;">
                    <table class="table is-bordered is-striped is-narrow is-hoverable">
                        <tbody>
                            <tr> <th>ID</th>           <td>{obj._id}</td> </tr>
                            <tr> <th>Code</th>         <td>{obj.code}</td> </tr>
                            <tr> <th>Name</th>         <td>{obj.name}</td> </tr>
                            <tr> <th>Description</th>  <td>{obj.description}</td> </tr>

                        </tbody>
                    </table>
                </div>

                <page-base-camera-list source={obj.cameras}></page-base-camera-list>
            </div>


        </div>
    </section>

</page-base-schemas>
