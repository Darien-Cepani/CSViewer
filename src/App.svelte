<svelte:head>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link href="https://fonts.googleapis.com/css2?family=Kode+Mono:wght@400..700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
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

    function formatTime(dateTimeString) {
      const dateObj = new Date(dateTimeString);
      return dateObj.toLocaleTimeString([], { hour: '2-digit', minute:'2-digit' });
    }

    /**
     * @type {any[]}
     */
     $: jsonData = [];
     $: isLoading = false; // For loading state

     async function loadCSV(date = null){
      isLoading = true; // Start loading indicator
      let fetchUrl = "";

      if (date) {
          const formattedDate = formatDate(date); // Ensure date is in correct format
          fetchUrl = '/archive/' + formattedDate.toString() + '.csv';
      } else {
          fetchUrl = '/live/live.csv';
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
            skipEmptyLines: true,
            complete: function(results) {
              jsonData = results.data.map(row => {
                // Extract and format time components
                row['Ora e fillimit'] = new Date(row['Ora e fillimit']);
                row['Ora e Mbylljes'] = new Date(row['Ora e Mbylljes']);
                return row; // Return the modified row
              });
              jsonData = jsonData;
            }
        });

        jsonData = parseResult.data;
        firstKey = Object.keys(jsonData[0])[0];
      isLoading = false; // Finished loading

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
    {#if firstKey != "<!doctype html>" && jsonData.length > 0}
      <DataTable jsonData={jsonData} formatTime={formatTime}/>
    {:else if isLoading}
      <p>Loading...</p>
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
    align-items: center;
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
      position: relative;
      height: 90vh;
      margin-top: 50px;
      max-height: 90vh;
      min-height: 0;
      width: fit-content;
    }

    h1{
      font-family: "Kode Mono";
      font-weight: 700;
      margin: 0;
    }
</style>
