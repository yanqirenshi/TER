<section-header>
    <section class="section">
        <div class="container">
            <h1 class="title is-{opts.no ? opts.no : 3}">
                {opts.title}
            </h1>
            <h2 class="subtitle">{opts.subtitle}</h2>

            <yield/>
        </div>
    </section>

    <style>
     section-header > .section {
         background: #1D0D37;
     }
     section-header > .section .title {
         color: #fff;
     }
     section-header > .section .subtitle {
         color: #fff;
     }
    </style>
</section-header>
