class TableColumn {
    constructor(param) {
        this._padding = param.padding ? param.padding : 0;
        this._values  = param.values;
    }
    columnsWidth (d) {
        let padding = this._padding;
        return d.w - padding * 2;
    }
    columnHeight () {
        return 22;
    }
    columnsContentsHeight (d) {
        let column_height = this.columnHeight();
        let column_len = d._column_instances.length;
        let contents_h = column_height * ((column_len == 0) ? 1 : column_len);
        let padding = this._padding;
        return contents_h;
    }
    columnsHeight (d) {
        let padding_top = 3;
        let padding_bottm = this._padding;
        return this.columnsContentsHeight(d) + padding_top + padding_bottm;
    }
    sortColumns (data) {
        let ids = [];
        let attributes = [];
        let timestamps = [];
        let others = [];
        for (var i in data) {
            if (data[i].column_type=='ID')
                ids.push(data[i]);
            else if (data[i].column_type=='ATTRIBUTE')
                attributes.push(data[i]);
            else if (data[i].column_type=='TIMESTAMP')
                timestamps.push(data[i]);
            else
                others.push(data[i]);
        }
        let sorter = (a,b)=>{ return a._id - b._id; };
        ids = ids.sort(sorter);
        attributes = attributes.sort(sorter);
        timestamps = timestamps.sort(sorter);
        others = others.sort(sorter);

        return [].concat(ids, attributes, timestamps, others);
    }
    draw (g, table, callback) {
        let padding = this._padding;

        g.append('rect')
            .attr('class', 'columns')
            .attr('x', (d) => { return padding; })
            .attr('y', (d) => { return table.headerHight(d); })
            .attr('width',  (d) => {
                return this.columnsWidth(d);
            })
            .attr('height', (d) => {
                return this.columnsContentsHeight(d);
            })
            .attr('fill', '#fefefe');

        let resize_tables = table.resize_tables;

        g.selectAll('text.column')
            .data((d) => {
                return this.sortColumns(d._column_instances);
            })
            .enter()
            .append('text')
            .attr('class', 'column')
            .attr('x', (d) => {
                d.x = padding + 6;
                return d.x;
            })
            .attr('y', (d, i) => {
                d.y = table.headerHight(d.table) + (i+1) * 22;
                return d.y;
            })
            .attr('font-size', 16 + 'px')
            .attr('height', (d) => {
                d.h = this.columnHeight();
                return d.h;
            })
            .text((d) => {
                let type = this._values.table.columns.column;
                dump(type);
                dump(d);
                if (type=='physical_name' && d.physical_name)
                    return d.physical_name;

                return d.logical_name;
            }).each(function (d) {
                // table ごとの max を算出
                let w = Math.ceil(this.getBBox().width) + padding * 4;
                let table = d._table;

                if (!resize_tables[table._id])
                    resize_tables[table._id] = {
                        table: table,
                        max_w: 0
                    };

                if (resize_tables[table._id].max_w < w)
                    resize_tables[table._id].max_w = w;
            }).on("click", (d) => {
                if (callback.click) callback.click(d);
            }).on("dblclick", (d) => {
                if (callback.dblclick) callback.dblclick(d);
            });
    }
}
