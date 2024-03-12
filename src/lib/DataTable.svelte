<script lang="ts">
    import { DataHandler, Datatable, Th, ThFilter } from '@vincjo/datatables'
    import { afterUpdate, onMount } from 'svelte';
    import MultiTagFilter from './MultiTagFilter.svelte';
    import TimePicker from './TimePicker.svelte';
    import moment from 'moment';
    import TimeSpanFilter from './TimeSpanFilter.svelte';

    export let formatTime;
    export let jsonData: any[] = [];
    let originalData: any[] = []; // To store original data
    export let handler = new DataHandler(jsonData, { rowsPerPage: 50 }); 
    const rows = handler.getRows();
    let columns = Object.keys(jsonData[0]);
    let referenceDate = jsonData.length > 0 ? jsonData[0]['Ora e fillimit'] : null;
    let filteredData = [];
    let activeFilters = [];   // Store active filters
    let workingData;
    $: filteredData, updateTable();

    function formatDuration(seconds) {
        const hours = Math.floor(seconds / 3600); 
        const minutes = Math.floor((seconds % 3600) / 60);
        const remainingSeconds = seconds % 60;

        return `${hours}h ${minutes}m ${remainingSeconds}s`;
    }

    let startTimeFilter = moment(referenceDate).startOf('day');
    let endTimeFilter = moment(referenceDate).endOf('day');

    function startEndFilter(isStart, time) {
         // Add this to reset filtering if a filter is cleared   
         if (!time) { 
            if (isStart) {
                startTimeFilter = moment(referenceDate).startOf('day');
            } else {
                endTimeFilter = moment(referenceDate).endOf('day');
            }
        } else {
            if (isStart) {
                startTimeFilter = time;
            } else {
                endTimeFilter = time;
            }
        }

        const existingFilterIndex = activeFilters.findIndex(f => f.type === 'timerange');
        console.log(existingFilterIndex);
        if (existingFilterIndex !== -1) {
            activeFilters[existingFilterIndex] = { type: 'timerange', startTime: startTimeFilter, endTime: endTimeFilter };
        } else {
            activeFilters.push({ type: 'timerange', startTime: startTimeFilter, endTime: endTimeFilter });
        }
        applyFilters();
    }

    function tagFilter(e) {
        console.log('tagFilter event received', e)
        const { column, tags } = e;

        // Find if a filter for this column already exists
        const existingFilterIndex = activeFilters.findIndex(f => f.type === 'tag' && f.column === column);

        if (tags.length === 0) {
            if (existingFilterIndex !== -1) {
                // Remove the filter for this column
                activeFilters.splice(existingFilterIndex, 1); 
            }
            filteredData = [...originalData]; // Reset when the last tag for this column is removed
        } else {
            if (existingFilterIndex !== -1) {
                // Update the existing filter
                activeFilters[existingFilterIndex].values = tags; 
            } else {
                // Add a new filter
                activeFilters.push({ type: 'tag', column, values: tags });
            }
        }
        applyFilters(); 
  }

  const timespanFilter = (event) => {
        const { min, max } = event.detail;
        handler.setRows(jsonData.filter(row => row["Kohezgjatja"] >= min && row["Kohezgjatja"] <= max));
    }

  function applyFilters() {
    workingData = [...jsonData]; // Start with a copy of original data
    activeFilters.forEach(filter => {
        if (filter.type === 'tag') {
      workingData = workingData.filter(row => filter.values.includes(String(row[filter.column]))); 
    } else if (filter.type === 'timerange') {
        workingData = workingData.filter(row => {
          let startTime = new Date(row['Ora e fillimit']);
          let endTime = new Date(row['Ora e Mbylljes']);

          // Updated logic
        let matchesStart = true; // Always match if startTime is null
        let matchesEnd = true; // Always match if endTime is null

        if (filter.startTime) { 
            matchesStart = startTime >= filter.startTime;
        }
        if (filter.endTime) {
            matchesEnd = endTime <= filter.endTime;
        }

          return matchesStart && matchesEnd;
        });
      }
    });
    filteredData = workingData; 
    updateTable();
  }

    function updateTable() {
        if (activeFilters.length > 0) { // Check if there are any active filters
            if (filteredData.length > 0) {
            handler.setRows(filteredData);
            } else {
            handler.setRows([]); // Clear the Datatable 
            // ... Display a "No Results" message ...
            }
        } else {
            // Initial Display (no filters applied)
            handler.setRows(jsonData); 
        }
    }

    

    afterUpdate(() => {
        if (jsonData.length === 0) return;
        originalData = [...jsonData]; // Store original on initial load
        applyFilters(); 
    });
</script>

<Datatable stickyHeader {handler} >
    <table>
        <thead>
            <tr>
                <Th {handler} orderBy={(row) => row["Operator"]}>Operator</Th>
                <Th {handler} orderBy="">Klienti</Th>
                <Th {handler} orderBy={(row) => row["Ora e fillimit"]}>Ora e fillimit</Th>
                <Th {handler} orderBy={(row) => row["Ora e Mbylljes"]}>Ora e Mbylljes</Th>
                <Th {handler} orderBy={(row) => row["Kohezgjatja"]}>Kohezgjatja</Th>
                <Th {handler} orderBy={(row) => row["Statusi"]}>Statusi</Th>
            </tr>
            <tr id="filters">
                <!-- Insert filters components for each column here -->
                <th>
                    <MultiTagFilter {handler} filterColumn={columns[0]} on:change={(e) => tagFilter(e.detail)} on:clear={(e) => tagFilter(e.detail)}/>
                </th>
                <th>
                    <MultiTagFilter {handler} filterColumn={columns[1]} on:change={(e) => tagFilter(e.detail)} on:clear={(e) => tagFilter(e.detail)}/>
                </th>
                <th>
                    <TimePicker isStart={true} on:change={(e) => startEndFilter(true, e.detail)} referenceDate={referenceDate} on:clearTime={applyFilters}/>
                </th>
                <th>
                    <TimePicker isStart={false} on:change={(e) => startEndFilter(false, e.detail)} referenceDate={referenceDate} on:clearTime={applyFilters}/>
                </th>
                <th>
                    <TimeSpanFilter data={jsonData} on:filterchanged={timespanFilter} {formatDuration}/>
                </th>
                <th>
                    <MultiTagFilter {handler} filterColumn={columns[5]} on:change={(e) => tagFilter(e.detail)} on:clear={(e) => tagFilter(e.detail)}/>
                </th>
            </tr>
        </thead>
        <tbody>
            {#each $rows as row}
                <tr>
                    <td>{row['Operator']}</td>
                    <td>{row['Klienti']}</td>
                    <td>{formatTime(row['Ora e fillimit'])}</td>
                    <td>{formatTime(row['Ora e Mbylljes'])}</td>
                    <td>{formatDuration(row['Kohezgjatja'])}</td>
                    {#if row['Statusi'] == "ANSWERED"}
                    <td style="color: white; background-color: green">{row['Statusi']}</td>
                    {:else if row['Statusi'] == "FAILED"}
                    <td style="color: white; background-color: red">{row['Statusi']}</td>
                    {:else if row['Statusi'] == "NO ANSWER"}
                    <td style="color: black; background-color: lightgray">{row['Statusi']}</td>
                    {:else if row['Statusi'] == "BUSY"}
                    <td style="color: black; background-color: orange">{row['Statusi']}</td>
                    {:else}
                    <td style="color: black; background-color: white">{row['Statusi']}</td>
                    {/if}
                </tr>
            {/each}
        </tbody>
    </table>
</Datatable>

<style>
  table{
    text-align:center;
		width:100%;
		border-collapse:separate;
		border-spacing:0;
  }
    thead *{
        background-color: white;
        position: sticky;
    }
    tbody{
        overflow: scroll;
    }
    tbody td {
        border: 1px solid #f5f5f5;
        padding: 4px 20px;
    }
    tbody tr {
        transition: all, 0.2s;
        z-index: 100;
    }
    tr#filters *{
        padding: 5px 15px;
        background-color: rgb(240, 240, 240);
        cursor: pointer;
        transition: all 250ms ease-in-out;
        font-size: 12px;
    }
    tr#filters *:hover{
        background-color: lightgray;
        cursor: pointer;
    }
    tbody tr:hover {
        background: #f5f5f5;
    }
</style>
