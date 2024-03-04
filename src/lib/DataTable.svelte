<script lang="ts">
    import { DataHandler, Datatable, Th, ThFilter } from '@vincjo/datatables'
    import { afterUpdate } from 'svelte';

    export let jsonData: any[] = [];

    export let handler = new DataHandler(jsonData, { rowsPerPage: 50 }); 
    const rows = handler.getRows();

    afterUpdate(() => {
        handler.setRows(jsonData);
    });
</script>

<Datatable stickyHeader {handler} >
    <table>
        <thead>
            <tr>
                <Th {handler} orderBy={(row) => row["Operator"]}>Operator</Th>
                <Th {handler} orderBy={(row) => row["Klienti"]}>Klienti</Th>
                <Th {handler} orderBy={(row) => row["Ora e fillimit"]}>Ora e fillimit</Th>
                <Th {handler} orderBy={(row) => row["Ora e Mbylljes"]}>Ora e Mbylljes</Th>
                <Th {handler} orderBy={(row) => row["Kohezgjatja"]}>Kohezgjatja</Th>
                <Th {handler} orderBy={(row) => row["Statusi"]}>Statusi</Th>
            </tr>
            <tr>
                <ThFilter {handler} filterBy={(row) => row["Operator"]} />
                <ThFilter {handler} filterBy={(row) => row["Klienti"]} />
                <ThFilter {handler} filterBy={(row) => row["Ora e fillimit"]} />
                <ThFilter {handler} filterBy={(row) => row["Ora e Mbylljes"]} />
                <ThFilter {handler} filterBy={(row) => row["Kohezgjatja"]} />
                <ThFilter {handler} filterBy={(row) => row["Statusi"]} />
            </tr>
        </thead>
        <tbody>
            {#each $rows as row}
                <tr>
                    <td>{row['Operator']}</td>
                    <td>{row['Klienti']}</td>
                    <td>{row['Ora e fillimit']}</td>
                    <td>{row['Ora e Mbylljes']}</td>
                    <td>{row['Kohezgjatja']}</td>
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
