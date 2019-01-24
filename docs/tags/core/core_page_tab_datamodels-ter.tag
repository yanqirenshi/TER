<core_page_tab_datamodels-ter>
    <section class="section">
        <div class="container">
            <h1 class="title is-4">TER図</h1>
            <h2 class="subtitle"></h2>
            <div class="contents">
                <p><pre>
  entity
    ^
    |
    +-------+---------+-------------+-------------+-------------+-------------+
    |       |         |             |             |             |             |
resource  event  comparative  correspondence  recursion  resouce-detail  event-detail


  identifier ------1:n------> identifier-instance
  attribute  ------1:n------> attribute-instance


  entity ------1:n------> identifier-instance
  entity ------1:n------> attribute-instance


  identifier-instance ------1:n------> port-ter-in
  identifier-instance ------1:n------> port-ter-out

  recouece : recouece
  recouece : resouce-detail
  recouece : recursion
  resouece : event
  event    : event-detail
  event    : event

  port-ter-in ------1:n------> edge-ter ------1:n------> port-ter-out</pre></p>
            </div>
        </div>
    </section>
</core_page_tab_datamodels-ter>
