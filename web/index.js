/* ******** */
/*  Request */
/* ******** */
var Uri = new Vanilla_URI();
var Request = new Vanilla_Ajax('http', 'localhost', '');
var API = new Vanilla_Ajax({
    scheme: _CONFIG.api.scheme,
    host: _CONFIG.api.host,
    port: _CONFIG.api.port,
    path: _CONFIG.api.path,
    credentials: 'include',
    callback: {
        401: function (r, api) {
            location.hash = '#sign-in';
        }
    }
});

/* ******* */
/*  Redux  */
/* ******* */
var ACTIONS = new Actions();
var REDUCER = new Reducer();
var STORE = new Store(REDUCER).init();

/* *********** */
/*  Metronome  */
/* *********** */
let Metronome = new Vanilla_metronome({
    interval: 1000 * 10,
    tick: function (count) {
        ACTIONS.fetchEr();
        ACTIONS.fetchTer();
        // ACTIONS.fetchErTables();
        // ACTIONS.fetchErColumns();
        // ACTIONS.fetchErColumnInstances();
        // ACTIONS.fetchErRelashonships();
    }
});

/* ****** */
/*  main  */
/* ****** */
route.start(function () {
    let hash = location.hash;
    let len = hash.length;

    if (len==0)
        location.hash = '#GRAPH';

    return hash.substring(1);
}());
