<inspector-table>
    <h1 class="title is-4">Table</h1>

    <section-container no="5" title="Name" name={getVal('name')}>
        <section-contents name={opts.name}>
            <p>{opts.name}</p>
        </section-contents>
    </section-container>

    <section-container no="5" title="Columns" columns={getVal('_column_instances')}>
        <section-contents columns={opts.columns}>
            <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth"
                   style="font-size:12px;">
                <thead>
                    <tr> <th>物理名</th> <th>論理名</th> <th>タイプ</th></tr>
                </thead>
                <tbody>
                    <tr each={opts.columns}>
                        <td>{physical_name}</td>
                        <td>{logical_name}</td>
                        <td>{data_type}</td>
                    </tr>
                </tbody>
            </table>
        </section-contents>
    </section-container>

    <section-container no="5" title="Edges" val={getVal('')}>
        <section-contents val={opts.val}>
            <p>{opts.val}</p>
        </section-contents>
    </section-container>

    <section-container no="5" title="Description" val={getVal('description')}>
        <section-contents val={opts.val}>
            <p>{opts.val}</p>
        </section-contents>
    </section-container>

    <style>
     inspector-table .section {
         padding: 11px;
         padding-top: 0px;
     }

     inspector-table section-contents .section {
         padding-bottom: 0px;
         padding-top: 0px;
     }

     inspector-table .contents, inspector-table .container {
         width: auto;
     }
    </style>


    <script>
     this.getVal = (name) => {
         let data = this.opts.data;
         if (!data) return '';

         if (name!='_column_instances')
             return data[name];
         else
             return data[name].sort((a,b)=>{ return (a._id*1) - (b._id*1); });
     };
    </script>
</inspector-table>
