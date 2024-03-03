<svelte:head>
  <link rel="icon" type="image/svg+xml" href="/logo.svg" />
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link href="https://fonts.googleapis.com/css2?family=Kode+Mono:wght@400..700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
</svelte:head>

<script>
  // import svelteLogo from './assets/svelte.svg'
  // import viteLogo from '/vite.svg'
  import DataTable from './lib/DataTable.svelte';
  import CalendarPicker from './lib/CalendarPicker.svelte';
  import { onMount } from 'svelte';
  import Papa from 'papaparse';
  import CriteriaFilter from './lib/CriteriaFilter.svelte';

  let todaysDate = new Date();
    /**
	 * @type {any}
	 */
    let selectedDate;
    
    function formatDate(date = new Date()) {
      const year = date.toLocaleString('default', {year: 'numeric'});
      const month = date.toLocaleString('default', {
        month: '2-digit',
      });
      const day = date.toLocaleString('default', {day: '2-digit'});

      return [year, month, day].join('-');
    }

     onMount(async () => {
        const response = await fetch('/live/' + formatDate(todaysDate) + '.csv');
        const csvText = await response.text();

        const parseResult = Papa.parse(csvText, {
            header: true,
            dynamicTyping: true
        });

        jsonData = parseResult.data;
    })

    /**
     * @type {any[]}
     */
    $: jsonData = []; // This is empty

    // function getFromArchive(date){
    //   const response = await fetch('/public/archive/' + formatDate(date) +'.csv');
    //     const csvText = await response.text();

    //     const parseResult = Papa.parse(csvText, {
    //     header: true,
    //     dynamicTyping: true
    //     });

    //     jsonData = parseResult.data;
    //     console.log(jsonData);
    // }

</script>

<main>
  <div class="topbar">
    <h1>CDR Logs</h1>
    <CalendarPicker />
    <p>Data e zgjedhur: {selectedDate}</p> 
    <a href="#" class="btn"><span class="liveDot">⦿</span>Live CSV</a>
  </div>

  {#if jsonData.length > 0}
    <DataTable jsonData={jsonData}/>
  {:else}
    <p>Loading...</p>
  {/if}
</main>

<style>
    .topbar{
      display: flex;
      flex-direction: row;
      align-items: center;
      gap: 20px;
    }

    .liveDot{
      color: red;
      margin-right: 5px;
      transition: all 250ms ease-in-out;
    }

    h1{
      font-family: "Kode Mono";
      font-weight: 700;
    }

    .btn{
      padding: 5px 10px;
      border-radius: 5px;
      border: 2px solid red;
      font-family: "Kode Mono";
      font-size: 20px;
      font-weight: bold;
      text-align: center;
      text-decoration: none;
      color: red;
      background-color: white;
      transition: all 250ms ease-in-out;
    }

    .btn:hover{
      color: white;
      background-color: red;
    }

    .btn:hover .liveDot{
      color: white;
    }
</style>
