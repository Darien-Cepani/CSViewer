<svelte:head>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link href="https://fonts.googleapis.com/css2?family=Kode+Mono:wght@400..700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
</svelte:head>

<script>
  import svelteLogo from './assets/svelte.svg'
  import viteLogo from '/vite.svg'
  import DataTable from './lib/DataTable.svelte';
  import CalendarPicker from './lib/CalendarPicker.svelte';
  import { onMount } from 'svelte';
  import Papa from 'papaparse';

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
        const response = await fetch('/public/live/' + formatDate(todaysDate) + '.csv');
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
    <h1>CSViewer</h1>
    <CalendarPicker />
    <p>Data e zgjedhur: {selectedDate}</p> 
    <a href="#" class="btn">Sot</a>
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

    h1{
      font-family: "Kode Mono";
      font-weight: 700;
    }

    .btn{
      padding: 10px 10px;
      border-radius: 5px;
      font-family: "Kode Mono";
      font-size: 20px;
      font-weight: bolder;
      text-align: center;
      text-decoration: none;
      color: white;
      background-color: red;
    }
</style>
