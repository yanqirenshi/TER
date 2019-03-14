class ErApp {
    constructor() {}
    ht2linkHt (data) {
        let out = {};

        if (data._id)
            out._id = data._id;

        if (data._class)
            out._class = data._class;

        return out;
    }
    stateER2Json (state) {
        let d = state;
        let out = {};

        out.columns = d.columns.list.slice();
        out.cameras = d.cameras.slice();
        out.column_instances = d.column_instances.list.map((d) => {
            let new_data = Object.assign({}, d);

            new_data._table = this.ht2linkHt(new_data._table);
            return new_data;
        });

        out.ports = d.ports.list.map((d) => {
            let new_data = Object.assign({}, d);

            new_data._column_instance = this.ht2linkHt(d._column_instance);
            return new_data;
        });

        out.relashonships = d.relashonships.list.map((d) => {
            let new_data = Object.assign({}, d);

            if (d._port_from)
                new_data._port_from = this.ht2linkHt(d._port_from);

            if (d._port_to)
                new_data._port_to = this.ht2linkHt(d._port_to);

            return new_data;
        });

        out.edges = d.edges.list.map((d) => {
            let new_data = Object.assign({}, d);

            if (d._port_from)
                new_data._port_from = this.ht2linkHt(d._port_from);

            if (d._port_to)
                new_data._port_to = this.ht2linkHt(d._port_to);

            return new_data;
        });

        return JSON.stringify(out, null, 3);

    }
    downloadJson (json) {
        var blob = new Blob([ json ], {type : 'application/json'});

        var a = document.createElement("a");
        a.href = URL.createObjectURL(blob);
        a.target = '_blank';
        a.download = 'er.' + moment().format('YYYYMMDDHHmmssZZ') + '.json';
        a.click();

    }
}
