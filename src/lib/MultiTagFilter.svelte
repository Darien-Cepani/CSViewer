<script lang="ts">
  import type { DataHandler } from '@vincjo/datatables'
  import { createEventDispatcher } from 'svelte';
  export let handler: DataHandler;
  export let filterColumn; // Allow customization
  let showMenu = false;

  const dispatch = createEventDispatcher();
  let selected = [];

  let types = handler.createCalculation(filterColumn).distinct((values) => {
        return values
    })

  function clearTags(){
    selected.length = 0;
    dispatch("clear", { column: filterColumn, tags: selected });
  }

</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<!-- svelte-ignore a11y-no-static-element-interactions -->
<div class="filterDropdown" on:click={() => (showMenu = !showMenu)}>
    Filter {filterColumn}

    {#if showMenu}
      <i class="fa-solid fa-chevron-up"></i>
    {:else}
      <i class="fa-solid fa-chevron-down"></i>
    {/if}

    {#if selected.length > 0}
        <button class="clear" on:click|stopPropagation={clearTags}>
            Clear
        </button>
    {/if}
</div>

{#if showMenu}
<article class="thin-scrollbar z-depth-2">
  
  {#each types as type}
      {@const { value, count } = type}
      <!-- svelte-ignore a11y-click-events-have-key-events -->
      <!-- svelte-ignore a11y-no-static-element-interactions -->
      <div on:click={() => { 
        if (selected.includes(value)) {
            selected = selected.filter(tag => tag !== value);
        } else {
            selected = [...selected, value];
        }
        dispatch('change', { column: filterColumn, tags: selected });
      }}
      class="btn select" class:active={selected.includes(value)}>
          <span>{value}</span>
          <code>{count}</code>
      </div>
  {/each}
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
      width: 170px;
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

  .select {
      justify-content: center;
      width: 100%;
      font-size: 15px;
      padding: 10px 0px;
      text-transform: none;
      cursor: pointer;
      transition: all 250ms ease-in-out;
  }

  .btn.select span {
      width: 88px;
      text-align: left;
  }

  .btn.select:hover {
    color: white;
      background: rgb(160, 0, 0);
  }
  .btn.select.active {
    color: white;
      background: red;
  }
</style>