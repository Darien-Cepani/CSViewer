<script lang="ts">
    import { DataHandler, Datatable, Th, ThFilter } from '@vincjo/datatables'
    import { afterUpdate } from 'svelte';

    export let jsonData: any[] = [];
    console.log(jsonData);

    const handler = new DataHandler(jsonData, { rowsPerPage: 50 }); 
    const rows = handler.getRows();
    console.log(rows);

    afterUpdate(() => {
        handler.setRows(jsonData);
    });
</script>

<Datatable {handler}>
    <table>
        <thead>
            <tr>
                <Th {handler} orderBy="Operator">Operator</Th>
                <Th {handler} orderBy="Klienti">Klienti</Th>
                <Th {handler} orderBy="Ora e fillimit">Ora e fillimit</Th>
                <Th {handler} orderBy="Ora e Mbylljes">Ora e Mbylljes</Th>
                <Th {handler} orderBy="Kohezgjatja">Kohezgjatja</Th>
                <Th {handler} orderBy="Statusi">Statusi</Th>
            </tr>
            <tr>
                <ThFilter {handler} filterBy="Operator" />
                <ThFilter {handler} filterBy="Klienti" />
                <ThFilter {handler} filterBy="Ora e fillimit" />
                <ThFilter {handler} filterBy="Ora e Mbylljes" />
                <ThFilter {handler} filterBy="Kohezgjatja" />
                <ThFilter {handler} filterBy="Statusi" />
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
                    {:else}
                    <td style="color: black; background-color: orange">{row['Statusi']}</td>
                    {/if}
                </tr>
            {/each}
        </tbody>
    </table>
</Datatable>

<style>
    * {
        font-family: "Montserrat";
    }
    thead {
        background: #fff;
    }
    tbody td {
        border: 1px solid #f5f5f5;
        padding: 4px 20px;
    }
    tbody td:last-child{
        font-weight: bold;
    }
    tbody tr {
        transition: all, 0.2s;
    }
    tbody tr:hover {
        background: #f5f5f5;
    }
    table {
    border-collapse: separate;
    border-spacing: 0;
    }

    thead {
        position: sticky;
        inset-block-start: 0;
    }
</style>
