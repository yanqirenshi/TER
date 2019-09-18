<page-base-camera-list>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">Camera</h1>
            <h2 class="subtitle"></h2>

            <div if={opts.source.length==0 }>
                <p>Camera は持っていません。</p>
            </div>

            <div if={opts.source.length!=0 }>

                <table class="table is-bordered is-striped is-narrow is-hoverable">
                    <thead>
                        <tr>
                            <th rowspan="3" colspan="2">Owner</th>
                            <th colspan="8">Camera</th>
                        </tr>
                        <tr>
                            <th rowspan="2">id</th>
                            <th rowspan="2">code</th>
                            <th rowspan="2">name</th>
                            <th colspan="3">Look at</th>
                            <th rowspan="2">magification</th>
                            <th rowspan="2">description</th>
                        </tr>
                        <tr>
                            <th>x</th>
                            <th>y</th>
                            <th>z</th>
                        </tr>
                    </thead>

                    <tbody>
                        <tr each={obj in opts.source}>
                            <td>{obj.owner._id}</td>
                            <td>{obj.owner.name}</td>
                            <td>{obj.camera._id}</td>
                            <td>{obj.camera.code}</td>
                            <td>{obj.camera.name}</td>
                            <td>{obj.camera.look_at.x}</td>
                            <td>{obj.camera.look_at.y}</td>
                            <td>{obj.camera.look_at.z}</td>
                            <td>{obj.camera.magnification}</td>
                            <td>{obj.camera.description}</td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </div>
    </section>

</page-base-camera-list>
