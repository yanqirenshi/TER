export default class Pool {
    list2pool (list, f) {
        let pool = {
            list: [],
            ht: {},
        };

        if (!list)
            return pool;

        if (f)
            return list.reduce((acc, val) => {
                const new_val = f(val);

                acc.list.push(new_val);

                acc.ht[new_val._id] = new_val;

                return acc;
            }, pool);
        else
            return list.reduce((acc, val) => {
                acc.list.push(val);

                acc.ht[val.id] = val;
                return acc;
            }, pool);
    }
}
