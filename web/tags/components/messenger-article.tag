<messenger-article class={opts.source.type}>

    <div class="head">
        <p class="contents">Header</p>
        <p class="operator" onclick={clickClose}>
            <i class="fas fa-times-circle"></i>
        </p>
    </div>

    <div class="body">
        <p>{opts.source.contents}</p>
    </div>

    <div class="foot">
        <p>{moment(opts.source._timestamp).format('YYYY-MM-DD HH:mm:ss')}</p>
    </div>

    <script>
     this.clickClose = () => {
         ACTIONS.closeMessage(this.opts.source);
     };
    </script>

    <style>
     messenger-article {
         display: flex;
         flex-direction: column;

         width: 222px;
         background: #fff;
         border-radius: 5px;
         margin-bottom: 22px;
         box-shadow: 0px 0px 11px #eee;
     }
     messenger-article.warning {
         box-shadow: 0px 0px 11px #ffec47;
     }
     messenger-article.error {
         box-shadow: 0px 0px 11px #CF2317;
     }
     messenger-article .head{
         border-radius: 5px 5px 0px 0px;

         background: #372247;
         color: #fff;
         font-weight: bold;
         font-size: 12px;
         padding: 6px 11px;
     }
     messenger-article .head {
         display: flex;
     }
     messenger-article .head .contents {
         flex-grow: 1;
     }
     messenger-article .body{
         flex-grow 1;
         padding: 8px;
         word-break: break-all;
     }
     messenger-article .foot{
         padding: 3px 6px;
         font-size: 9px;
         text-align: right;
         color: #888;
     }
    </style>

</messenger-article>
