<script lang="ts">
    import { DataHandler, Datatable, Th, ThFilter } from '@vincjo/datatables'
    import { afterUpdate, onMount } from 'svelte';
    import MultiTagFilter from './MultiTagFilter.svelte';
    import TimePicker from './TimePicker.svelte';
    import TimeSpanFilter from './TimeSpanFilter.svelte';

    export let formatTime;
    export let jsonData: any[] = [];
    export let handler = new DataHandler(jsonData, { rowsPerPage: 50 }); 
    const rows = handler.getRows();
    let columns = Object.keys(jsonData[0]);
    let referenceDate = null;
    let filteredData;

    function formatDuration(seconds) {
        const hours = Math.floor(seconds / 3600); 
        const minutes = Math.floor((seconds % 3600) / 60);
        const remainingSeconds = seconds % 60;

        return `${hours}h ${minutes}m ${remainingSeconds}s`;
    }

    let startTimeFilter = null;
    let endTimeFilter = null;

    function updateFilters(isStart, time) {
        // console.log("updateFilters called", isStart, time);

        if (isStart) {
            startTimeFilter = time;
        } else {
            endTimeFilter = time;
        }
        applyFilters();
    }

    function applyFilters() {
        if (jsonData.length === 0) return;
        let filteredData = jsonData;  // Start with initial data

        if (jsonData.length > 0) {
            referenceDate = jsonData.length > 0 ? jsonData[0]['Ora e fillimit'] : null;
            referenceDate = new Date(referenceDate);
        }

        // Apply Time Filters
        if (startTimeFilter) {
            filteredData = filteredData.filter(row => new Date(row['Ora e fillimit']) >= startTimeFilter); 
        }
        if (endTimeFilter) {
            filteredData = filteredData.filter(row => new Date(row['Ora e Mbylljes']) <= endTimeFilter); 
        }

        // Apply MultiTag Filters 
        columns.forEach((column, index) => {
            const tagFilter = handler.getFilters()[0]; // Assuming one MultiTagFilter per column
            if (tagFilter) {
                const selectedTags = tagFilter.getSelected();
                if (selectedTags.length > 0) {
                    filteredData = filteredData.filter(row => selectedTags.includes(row[column]));
                }
            }
        });
        
        // Implement your filtering logic here using startTimeFilter and endTimeFilter
        filteredData = jsonData.filter((row) => {
            let startTime = new Date(row['Ora e fillimit']);
            let endTime = new Date(row['Ora e Mbylljes']);

            let matchesStart = !startTimeFilter || startTime >= startTimeFilter;
            let matchesEnd = !endTimeFilter || endTime <= endTimeFilter;

            return matchesStart && matchesEnd;
        });
            handler.setRows(filteredData); // Changed from jsonData to filteredData
    }

    function resetFilters(isStart) { // Modify to handle 'isStart'
        if (isStart) {
            startTimeFilter = null;
        } else {
            endTimeFilter = null;
        }
        applyFilters();
    }

    const handleFilterChange = (event) => {
        const { min, max } = event.detail;
        handler.setRows(jsonData.filter(item => item["Kohezgjatja"] >= min && item["Kohezgjatja"] <= max));
    }

    afterUpdate(() => {
        if (jsonData.length === 0) return;
        handler.setRows(jsonData);
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
                    <MultiTagFilter {handler} on:filterChanged={applyFilters} filterColumn={columns[0]}/>
                </th>
                <th>
                    <MultiTagFilter {handler} filterColumn={columns[1]}/>
                </th>
                <th>
                    <TimePicker isStart={true} on:change={(e) => updateFilters(true, e.detail)} referenceDate={referenceDate} on:clear={(e) => resetFilters(e.detail.isStart)}/>
                </th>
                <th>
                    <TimePicker isStart={false} on:change={(e) => updateFilters(false, e.detail)} referenceDate={referenceDate} on:clear={(e) => resetFilters(e.detail.isStart)}/>
                </th>
                <th>
                    <TimeSpanFilter data={jsonData} on:filterchanged={handleFilterChange} {formatDuration}/>
                </th>
                <th>
                    <MultiTagFilter {handler} filterColumn={columns[5]}/>
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
        justify-content: center !important;
        background: #fff;
        position: sticky;
		inset-block-start: 0;
    }
    tbody td {
        border: 1px solid #f5f5f5;
        padding: 4px 20px;
    }
    tbody tr {
        transition: all, 0.2s;
    }
    tbody tr:hover {
        background: #f5f5f5;
    }
</style>
