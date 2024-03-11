<script lang="ts">
  import type { DataHandler } from '@vincjo/datatables'
  export let handler: DataHandler;
  export let filterColumn; // Allow customization
  let showMenu = false;

  let types = handler.createCalculation(filterColumn).distinct((values) => {
        return values
    })

  const filter = handler.createAdvancedFilter(filterColumn)
  const selected = filter.getSelected()
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

    {#if $selected.length > 0}
        <button class="clear" on:click|stopPropagation={() => filter.clear()}>
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
      <div on:click={() => filter.set(value)} class="btn select" class:active={$selected.includes(value)}>
          <span>{value}</span>
          <code>{count}</code>
      </div>
  {/each}
</article>
{/if}

<style>

.filterDropdown{
    position: relative;
    padding: 5px 15px;
    background-color: rgb(240, 240, 240);
    cursor: pointer;
    transition: all 250ms ease-in-out;
    margin-bottom: 8px;
    font-size: 12px;
  }

  article {
      position: absolute;
      border-radius: 4px;
      width: 100%;
      background: #fafafa;
      border: 1px solid #e0e0e0;
  }

  .filterDropdown:hover{
    background-color: rgb(207, 207, 207);
    cursor: pointer;
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