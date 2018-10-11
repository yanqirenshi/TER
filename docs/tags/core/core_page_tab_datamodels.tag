<core_page_tab_datamodels>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">TER図</h1>
            <h2 class="subtitle"></h2>
            <div class="contents">
                <p><pre>
  entity
    ^
    |
    +-------+---------+-------------+-------------+
    |       |         |             |             |
resource  event  comparative  correspondence  recursion


  identifier ------1:n------> identifier-instance
  attribute  ------1:n------> attribute-instance


  entity ------1:n------> identifier-instance
  entity ------1:n------> attribute-instance


  identifier-instance ------1:n------> port-ter-in
  identifier-instance ------1:n------> port-ter-out


  port-ter-in ------1:n------> edge-ter ------1:n------> port-ter-out</pre></p>
            </div>
        </div>
    </section>

    <section class="section">
        <div class="container">
            <h1 class="title is-4">ER図</h1>
            <h2 class="subtitle"></h2>
            <div class="contents">
                <p><pre>
  table  ------1:n------> column-instance


  column ------1:n------> column-instance


  column-instance -------1:1------> port-er-in
  column-instance -------1:1------> port-er-out


  port-er-in ------1:1------> edge-er ------1:1------> port-er-out</pre></p>
            </div>
        </div>
    </section>

</core_page_tab_datamodels>
