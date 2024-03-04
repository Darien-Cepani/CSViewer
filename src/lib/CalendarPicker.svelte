<Flatpickr
    options="{ flatpickrOptions }"
    bind:value={selectedDate}
    element="#my-picker"
>
    <div class="flatpickr" id="my-picker">
        <input class="datePicker" type="text" placeholder="Zgjidh daten.." data-input/>
        
        <!-- svelte-ignore a11y-invalid-attribute -->
            <a href="#" id="liveBtn" class="btn" class:active={isActive} title="load" on:click={openLive}>
                <span class="liveDot">⦿</span>
                Live CSV
            </a>
    </div>
</Flatpickr>

<script lang="ts">
    import Flatpickr from 'svelte-flatpickr';

    import 'flatpickr/dist/flatpickr.css';
    import 'flatpickr/dist/themes/light.css';
  import { onMount } from 'svelte';

    export let formattedTodays;
    export let selectedDate;
    export let formatDate

    function openLive() {
        selectedDate = formattedTodays;
    }

    // Reactivity for class change:
    let isActive = false;
    $: isActive = selectedDate === formattedTodays;
    $: selectedDate = formatDate(selectedDate);

    onMount(() => {
        isActive = selectedDate === formattedTodays;
    });

    const flatpickrOptions = {
        defaultDate: formattedTodays,
        weekNumbers: true,
        maxDate: "today",
        altInput: true,
        altFormat: "F j, Y",
        dateFormat: "Y-m-d",
    };
</script>

<style>
    .datePicker{
        font-family: "Kode Mono";
        font-size: 20px;
        padding: 5px 10px;
    }

    .liveDot{
      color: red;
      margin-right: 5px;
      transition: all 250ms ease-in-out;
    }

    .btn{
      padding: 5px 10px;
      border-radius: 5px;
      border: 2px solid red;
      font-family: "Kode Mono";
      font-size: 20px;
      font-weight: bold;
      text-align: center;
      text-decoration: none;
      color: red;
      background-color: white;
      transition: all 250ms ease-in-out;
    }

    .btn:hover{
      color: white;
      background-color: red;
    }
    .btn.active{
      color: white;
      background-color: red;
    }

    .btn.active .liveDot{
      color: white;
    }

    .btn:hover .liveDot{
      color: white;
    }
</style>