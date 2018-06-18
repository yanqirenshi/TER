<section-list>
    <table class="table is-bordered is-striped is-narrow is-hoverable">
        <thead>
            <tr>
                <th>機能</th>
                <th>概要</th>
            </tr>
        </thead>
        <tbody>
            <tr each={data()}>
                <td><a href={hash}>{title}</a></td>
                <td>{description}</td>
            </tr>
        </tbody>
    </table>

    <script>
     this.data = () => {
         return opts.data.filter((d) => {
             if (d.code=='root') return false;

             let len = d.code.length;
             let suffix = d.code.substr(len-5);
             if (suffix=='_root' || suffix=='-root')
                 return false;

             return true;
         });
     };
    </script>
</section-list>
