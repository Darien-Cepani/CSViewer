<Flatpickr
    options="{ flatpickrOptions }"
    bind:value={selectedDate}
    element="#my-picker"
>
    <div class="flatpickr" id="my-picker">
        <input class="datePicker" type="text" placeholder="Zgjidh daten.." data-input/>

        <!-- svelte-ignore a11y-invalid-attribute -->
        <a href="#" class="btn" title="load" on:click={loadToday}>
            <span class="liveDot">⦿</span>
            Live CSV
        </a>
    </div>
</Flatpickr>

<script lang="ts">
    import Flatpickr from 'svelte-flatpickr';

    import 'flatpickr/dist/flatpickr.css';
    import 'flatpickr/dist/themes/light.css';

    export let formattedTodays;
    export let selectedDate = formattedTodays;

    

    function loadToday(){
        selectedDate = formattedTodays;
    }

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

    .btn:hover .liveDot{
      color: white;
    }
</style>