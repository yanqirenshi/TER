import React from 'react';

import D3Ter from './D3Ter.js';
import TER_DATA from './TER_DATA.js';

const style = {
    root: {
        width: '100vw',
        height: '100vh',
    }
};

function App() {
    return (
        <div style={style.root}>
          <D3Ter graph_data={TER_DATA}/>
        </div>
    );
}

export default App;
