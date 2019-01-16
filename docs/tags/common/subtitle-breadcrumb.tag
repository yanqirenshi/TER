<subtitle-breadcrumb>

    <nav class="breadcrumb" aria-label="breadcrumbs">
        <ul>
            <li each={path()}>
                <a class="{active ? 'is-active' : ''}"
                   href={href}
                   aria-current="page">{label}</a>
            </li>
        </ul>
    </nav>

    <style>
     subtitle-breadcrumb { display: block; }
     subtitle-breadcrumb > nav.breadcrumb { padding-left: 22px; }
    </style>

    <script>
     this.path = () => {
         let hash = location.hash;
         let path = hash.split('/');

         if (path[0] && path[0].substr(0,1)=='#')
             path[0] = path[0].substr(1);

         let out = [];
         let len = path.length;
         let href = null;
         for (var i in path) {
             href = href ? href + '/' + path[i] : '#' + path[i];

             if (i==len-1)
                 out.push({
                     label: path[i],
                     href: hash,
                     active: true
                 });

             else
                 out.push({
                     label: path[i],
                     href: href,
                     active: false
                 });
         }
         return out;
     }
    </script>

</subtitle-breadcrumb>
