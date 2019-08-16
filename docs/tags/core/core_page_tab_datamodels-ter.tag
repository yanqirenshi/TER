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


  identifier <-----(1:n, :subset-of)------ identifier-instance
  attribute  <-----(1:n, :subset-of)------ attribute-instance


  entity ------(1:n, :have-to-native)------> identifier-instance
         ------(1:n, :have-to-foreigner)---> identifier-instance

  entity ------(1:n, :have-to-native)------> attribute-instance


  identifier-instance ------(1:n, :have-to)------> port-ter
  identifier-instance ------(1:n, :have-to)------> port-ter

  recouece : recouece
  recouece : resouce-detail
  recouece : recursion
  resouece : event
  event    : event-detail
  event    : event

  port-ter(:out) ------(1:n, :->)------> port-ter(:in)</pre></p>
            </div>
        </div>
    </section>
</core_page_tab_datamodels-ter>
