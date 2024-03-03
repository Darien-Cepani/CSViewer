<Flatpickr
    options="{ flatpickrOptions }"
    bind:value="{date}"
    element="#my-picker"
>
    <div class="flatpickr" id="my-picker">
        <input class="datePicker" type="text" placeholder="Zgjidh daten.." data-input />
    </div>
</Flatpickr>

<script>
    import Flatpickr from 'svelte-flatpickr';

    import 'flatpickr/dist/flatpickr.css';
    import 'flatpickr/dist/themes/light.css';

    let date = null;
    const flatpickrOptions = {};
</script>

<style>
    .datePicker{
        font-family: "Kode Mono";
        font-size: 20px;
        padding: 5px 10px;
    }
</style>