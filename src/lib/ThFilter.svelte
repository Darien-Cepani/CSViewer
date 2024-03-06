<script>
    import { onMount, createEventDispatcher } from 'svelte';
  
    export let data = [];
    export let column = '';
  
    let uniqueTags = [];
    let selectedTags = new Set();
    let showDropdown = false;
    const dispatch = createEventDispatcher();

  
    // Calculate unique tags and filtered data on mount
    onMount(() => {
      uniqueTags = [...new Set(data.map((row) => row[column]))];
    });
  
    // Computed property to derive filtered data
    $: filteredData = data.filter((row) => {
        return selectedTags.size === 0 || selectedTags.has(row[column]);
    });
  
    // Function to toggle tags
    const toggleTag = (tag) => {
        if (selectedTags.has(tag)) {
        selectedTags.delete(tag);
        } else {
        selectedTags.add(tag);
        }
        dispatch('filterChange', { selectedTags: Array.from(selectedTags) }); 
    };
  </script>

<div class="filter-container">
    <input 
      type="text" 
      readonly 
      class="filter-input" 
      value={Array.from(selectedTags).join(', ')}
      on:click={() => showDropdown = true}
    />
  
    {#if showDropdown}
      <ul class="dropdown-list">
        {#each uniqueTags as tag}
          <!-- svelte-ignore a11y-click-events-have-key-events -->
          <!-- svelte-ignore a11y-no-noninteractive-element-interactions -->
          <li
            class="dropdown-item"
            class:active={selectedTags.has(tag)}
            on:click={() => {toggleTag(tag); showDropdown=false}}
          >
            {tag}
          </li>
        {/each}
      </ul>
    {/if}
  </div>
  
  <style>
    .filter-container {
        position: relative; /* Contain the dropdown */
        }

        .filter-input {
        overflow-x: auto; /* Enable horizontal scrolling */
        white-space: nowrap; /* Keep tags on one line */
        }

        .dropdown-list {
        position: absolute;
        background-color: white;
        /* box-shadow: ... add some box shadow; */
        list-style: none;
        padding: 0;
        margin: 0;
        z-index: 1; /* Ensure dropdown is on top */;
        }

        .dropdown-item {
        cursor: pointer;
        }

    .tag-list {
  display: flex;
  flex-wrap: wrap;
  list-style: none;
  margin: 0;
  padding: 0;
}

.tag {
  background-color: #eee;
  color: #333;
  border-radius: 5px;
  padding: 5px 10px;
  margin: 5px;
  cursor: pointer;
}

.tag.active {
  background-color: #007bff;
  color: white;
}
  </style>
  