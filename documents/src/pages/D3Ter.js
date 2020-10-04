import React, { useState, useEffect } from 'react';

import AssholeD3TER from '../js/AssholeD3TER.js';

const style = {
    root: {
        width: '100%',
        height: '100%',
        padding: 0,
        margin: 0,
        overflow: 'hidden',
        background: 'rgba(254, 244, 244, 0.8)',
    }
};

function D3Ter(props) {
    const [ass] = useState(new AssholeD3TER().init({
        svg: { selector: '#asshole-graph' }
    }));

    useEffect(() => {
        ass.focus();
        ass.data(props.graph_data);
    });

    return (
        <div style={style.root}>
          <svg id='asshole-graph'/>
        </div>
    );
}

export default D3Ter;
