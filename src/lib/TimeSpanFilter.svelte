<script>
    import { onMount } from 'svelte';

    export let data; // Pass the table data
    export let filterColumn = 'Kohezgjatja'; // Column to filter on
    export let formatDuration;

    let minRange = 0;
    let maxRange = 0;
    let rangeValues = [0, 0];

    onMount(() => {
        // Calculate initial min and max values
        minRange = Math.min(...data.map(row => row[filterColumn]));
        maxRange = Math.max(...data.map(row => row[filterColumn]));
        rangeValues = [minRange, maxRange];
        // console.log(rangeValues);
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

<div class="filter-container">
    <input type="range" min={minRange} max={maxRange} class="dual-slider"
           bind:value={rangeValues} on:change={dispatchFilter}> 

    <div class="range-labels">
       <span>{formatDuration(rangeValues[0])}</span>  
       <span>{formatDuration(rangeValues[1])}</span> 
    </div>
</div>

<style>
    .filter-container {
        display: flex;
        flex-direction: column;
        font-size: 12px;
    }

    .dual-slider {
        -webkit-appearance: none; /* Remove default styling */
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
        background: #fff;
        border: 1px solid #888;  
        border-radius: 50%;  
        cursor: pointer;
    }

    .dual-slider::-webkit-slider-thumb:nth-child(2) { 
        right: 0;
        -webkit-appearance: none;
        width: 15px;
        height: 15px;
        background: red;
        border: 1px solid #888;  
        border-radius: 50%;  
        cursor: pointer;
    }

    .range-labels {
        display: flex;
        justify-content: space-between;
    }
</style>