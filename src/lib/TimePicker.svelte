<script>
    import Flatpickr from 'svelte-flatpickr';
    import {createEventDispatcher} from 'svelte'; 
    import "../assets/TimePicker.css";

    const dispatch = createEventDispatcher();
  
    export let isStart = false;
    export let referenceDate;
    let selectedTime = null;

    const config = {
      enableTime: true,
      noCalendar: true,
      dateFormat: 'h:i K',
      onChange: (selectedDates) => {
        selectedTime = selectedDates[0];

        if (referenceDate) {
          if (selectedTime) { 
                selectedTime.setDate(referenceDate.getDate()); 
                selectedTime.setMonth(referenceDate.getMonth()); 
                selectedTime.setFullYear(referenceDate.getFullYear());
            } else {
                selectedTime = null; // Initialize if null
            }
        }
        dispatch('change', selectedTime); // Dispatch the event
    }
    };
  
    // Function to handle clearing the time
    function clearTime() {
      selectedTime = null;
      referenceDate = null;
      dispatch('change', selectedTime);  
      dispatch('clear', { isStart }); // Pass 'isStart' information
    }
  </script>
  
  <Flatpickr bind:value={selectedTime} options={config} />

  {#if selectedTime}
      <button on:click={clearTime} class="btn clear">Clear</button>
  {/if}