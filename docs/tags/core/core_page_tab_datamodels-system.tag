<core_page_tab_datamodels-system>
    <section class="section">
        <div class="container">
            <h1 class="title is-4">共通</h1>
            <h2 class="subtitle"></h2>
            <div class="contents">
                <p><pre>
  ghost-shadow ---1:1---> modeler

  system ---1:n---> schema
  system ---1:n---> campus

  modeler ---1:n---> system <---1:n--- schema
  modeler ---1:n---> system <---1:n--- campus

  modeler ---1:n---> camera <---1:n--- schema
  modeler ---1:n---> camera <---1:n--- campus
                </pre></p>
            </div>
        </div>
    </section>
</core_page_tab_datamodels-system>
