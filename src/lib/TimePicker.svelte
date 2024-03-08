<script>
    import Flatpickr from 'svelte-flatpickr';
    import 'flatpickr/dist/flatpickr.min.css'; 
    import {createEventDispatcher} from 'svelte';

    const dispatch = createEventDispatcher();
  
    export let isStart = false;
    let selectedTime = null;
  
    const config = {
      enableTime: true,
      noCalendar: true,
      dateFormat: 'h:i K',
      onChange: (selectedDates) => {
        selectedTime = selectedDates[0];
        dispatch('change', selectedTime); // Dispatch the event
    }
    };
  
    // Function to handle clearing the time
    function clearTime() {
      selectedTime = null;
      // Implement logic to reset your data table filter here
    }
  </script>
  
  <Flatpickr bind:value={selectedTime} options={config} />
  
  {#if selectedTime}
      <button on:click={clearTime}>Clear</button>
  {/if}
  