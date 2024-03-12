<script>
// @ts-nocheck

    import { onMount } from 'svelte';

    export let data; // Pass the table data
    export let filterColumn = 'Kohezgjatja'; // Column to filter on
    export let formatDuration;
    let showMenu =  false;

    let minRange = 0;
    let maxRange = 0;
    let rangeValues = [0, 0];

    onMount(() => {
        // Calculate initial min and max values
        minRange = Math.min(...data.map(row => row[filterColumn]));
        maxRange = Math.max(...data.map(row => row[filterColumn]));
        rangeValues = [minRange, maxRange];
        console.log(rangeValues);
    });

    // Function to dispatch the filter event
    const dispatchFilter = () => {
        const event = new CustomEvent('filterchanged', { 
            detail: {
                min: rangeValues[0],
                max: rangeValues[1]
            }
        });
        dispatchEvent(event);
    };

</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<!-- svelte-ignore a11y-no-static-element-interactions -->
<div class="filterDropdown" on:click={() => (showMenu = !showMenu)}>
    Filter Kohezgjatja
    {#if showMenu}
      <i class="fa-solid fa-chevron-up"></i>
    {:else}
      <i class="fa-solid fa-chevron-down"></i>
    {/if}

    {#if showMenu}
        <button class="clear">
            Clear
        </button>
    {/if}
</div>

{#if showMenu}
<article class="thin-scrollbar z-depth-2">
    <input type="range" min={minRange} max={maxRange} class="dual-slider"
           bind:value={rangeValues} on:change={dispatchFilter}> 

    <div class="range-labels">
       <span>{formatDuration(rangeValues[0])}</span>  
       <span>{formatDuration(rangeValues[1])}</span> 
    </div>
</article>
{/if}


<style>
.filterDropdown{
        display: table-cell;
    padding: 7px 20px;
    border: 1px solid lightgray;
  }

  article {
    position: fixed;
      border-radius: 4px;
      margin: 5px 0 0 -15px;
      width: 245px;
      background: #fafafa;
      border: 1px solid #e0e0e0;
      transition: all 250ms ease-in-out;
  }

  button {
      color: white;
      background-color: red;
      border: 0;
      padding: 5px;
      font-size: 11px;
      border-radius: 4px;
      margin-left: 8px;
      cursor: pointer;
      transition: all 250ms ease-in-out
  }

  button:hover{
      background-color: rgb(160, 0, 0);
  }

    .dual-slider {
        -webkit-appearance: none; /* Remove default styling */
        appearance: none;
        width: 100%;
        height: 5px;         
        background: #ccc;      
        outline: none;       
    }

    .dual-slider::-webkit-slider-runnable-track {
        height: 5px;       
        background: #555; 
    }

    /* Style the slider thumbs for the dual range */
    .dual-slider::-webkit-slider-thumb { 
        left: 0;
        -webkit-appearance: none;
        width: 15px;
        height: 15px;
        background: red;
        border-radius: 5px;  
        cursor: pointer;
    }

    .dual-slider::-webkit-slider-thumb:nth-child(2) { 
        left: 0;
        -webkit-appearance: none;
        width: 15px;
        height: 15px;
        background: red;
        border-radius: 5px;  
        cursor: pointer;
    }

    .range-labels {
        display: flex;
        justify-content: space-between;
    }
</style>