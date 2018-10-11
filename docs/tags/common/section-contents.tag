<section-contents>
    <section class="section">
        <div class="container">
            <h1 class="title is-{opts.no ? opts.no : 3}">
                {opts.title}
            </h1>
            <h2 class="subtitle">{opts.subtitle}</h2>

            <div class="contents">
                <yield/>
            </div>
        </div>
    </section>

    <style>
     section-contents > section.section {
         padding: 0.0rem 1.5rem 2.0rem 1.5rem;
     }
    </style>

    <script>
     // dump(this.opts.no)
    </script>
</section-contents>
