<svelte:head>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link href="https://fonts.googleapis.com/css2?family=Kode+Mono:wght@400..700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
</svelte:head>

<script>
  import DataTable from './lib/DataTable.svelte';
  import CalendarPicker from './lib/CalendarPicker.svelte';
  import { onMount } from 'svelte';
  import Papa from 'papaparse';

  let todaysDate = new Date();
  let formattedTodays = formatDate(todaysDate);
  let selectedDate = formattedTodays; // This is where the user selected date should be stored
  let firstKey = "";

  $: selectedDate = formatDate(selectedDate);

    export function formatDate(dateInput) {
      // Handle both Date objects and string inputs
      let date;
      if (typeof dateInput === 'string') {
        date = new Date(dateInput);
      } else {
        date = dateInput;
      }

      // Format the date components
      const year = date.toLocaleString('default', { year: 'numeric' });
      const month = date.toLocaleString('default', { month: '2-digit' });
      const day = date.toLocaleString('default', { day: '2-digit' });

      // Combine the formatted components
      return [year, month, day].join('-');
    }

    /**
     * @type {any[]}
     */
     $: jsonData = [];

     async function loadCSV(date = null){
      let fetchUrl = "";

      if (date) {
          const formattedDate = formatDate(date); // Ensure date is in correct format
          fetchUrl = '/archive/' + formattedDate.toString() + '.csv';
      } else {
          fetchUrl = '/LiveCSV/Master.csv';
      }
      
      // If a date is provided, fetch from archive
      try {
        const response = await fetch(fetchUrl);
        if (!response.ok) {
            throw new Error(`Failed to fetch CSV: ${response.status}`);
        }

        const csvText = await response.text();
        const parseResult = Papa.parse(csvText, {
            header: true,
            dynamicTyping: true,
            skipEmptyLines: true
        });

        jsonData = parseResult.data;
        firstKey = Object.keys(jsonData[0])[0]; // Assuming you need this

        return jsonData; // Return the parsed data
    } catch (error) {
        console.error("Error fetching data:", error);
        return null; // Indicate an error occurred
    }
     }


    $: if(selectedDate != formattedTodays){
      loadCSV(selectedDate);
    } else {
      loadCSV();
    }

    onMount(async () => {
      loadCSV()
    })

</script>

<main>
  <div class="topbar">
    <h1>CDR Logs</h1>
    <CalendarPicker formattedTodays={formattedTodays} formatDate={formatDate} bind:selectedDate={selectedDate}/>
  </div>

  <div class="datatableContainer">
    {#if firstKey != "<!doctype html>"}
      <DataTable jsonData={jsonData}/>
    {:else}
      <p>File doesn't exist</p>
    {/if}
  </div>
</main>

<style>
  main{
    display: flex;
    flex-direction: column;
    width: fit-content;
  }
    .topbar{
      position: absolute;
      top: 0;
      left: 0;
      display: flex;
      flex-direction: row;
      justify-content: center;
      padding: 10px 0px;
      width: 100%;
      margin: 0 auto;
      display: flex;
      flex-direction: row;
      align-items: center;
      gap: 30px;
      box-shadow: 0 1px 1px 1px rgba(0,0,0,0.1);
    }

    .datatableContainer{
      margin-top: 60px;
      height: 89vh;
      width: fit-content;
    }

    h1{
      font-family: "Kode Mono";
      font-weight: 700;
      margin: 0;
    }
</style>
