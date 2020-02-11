<modal-choose-system-selected>

    <p>{systemName()}</p>

    <script>
     this.systemName = () => {
         let system = opts.source;

         if (!system)
             'Please select System....';

         return system.code + " : " + system.name;
     };
    </script>

    <style>
     modal-choose-system-selected {
         display: block;
         padding: 22px;
         background: #eeeeee;
         margin-bottom: 22px;
         border-radius: 5px;
     }
    </style>

</modal-choose-system-selected>
