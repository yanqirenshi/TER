<markdown-preview>
    this.root.innerHTML = opts.data

    <script>
     this.on('update', () => {
         this.root.innerHTML = this.opts.data;
     });
    </script>

    <style>
     markdown-preview h1 {
         font-weight: bold;
         font-size: 20px;
         margin-top: 11px;
         margin-bottom: 6px;
     }
     markdown-preview h2 {
         font-weight: bold;
         font-size: 18px;
         margin-top: 8px;
         margin-bottom: 4px;
     }
     markdown-preview h3 {
         font-weight: bold;
         font-size: 16px;
         margin-top: 6px;
         margin-bottom: 3px;
     }
     markdown-preview h4 {
         font-weight: bold;
         font-size: 14px;
         margin-top: 6px;
         margin-bottom: 3px;
     }
     markdown-preview h5 {
         font-weight: bold;
         font-size: 12px;
         margin-bottom: 4px;
     }
     markdown-preview * {
         font-size: 12px;
     }
    </style>

    <style>
     markdown-preview table {
         border-collapse:  collapse;
     }

     markdown-preview td {
         border: solid 0.6px #888888;
         padding: 2px 5px;
     }
     markdown-preview th {
         border: solid 0.6px #888888;
         padding: 2px 5px;
         background: #eeeeee;
     }
    </style>
</markdown-preview>
