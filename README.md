# CSV Filter

A CSV file reader and filtering tool that allows you to display and interact with CSV files from both a "live" folder (for today's data) and an "archive" folder (for historical data).

## Technologies Used

* Svelte
* Docker
* HTML
* CSS
* JavaScript
* Node.js
* Libraries:
    * @vincjo/datatables
    * papaparse
    * svelte-flatpickr
    * svelte-select 
    * flatpickr
    * vite

## Installation Instructions

**Prerequisites**

* Node.js
* Docker (for production environments)

**Steps**

1. Clone the repository: `git clone https://github.com/AlpineEdge/csv-filter.git`
2. Install dependencies: `npm install`
3. **Development:**  Run `npm run dev`
4. **Production:** 
   *  Build the Docker image: `docker compose build`
   *  Run the container: `docker compose up -d`

## Usage Instructions

* The application expects "live" CSV files for the current date to be located in a folder named `live`.
* Archived CSV files should reside within a folder named `archive`. Archived files must be named according to the format `YYYY-MM-DD.csv`.
* A datepicker component allows users to select historical data from the archive.
* The application provides various filtering and ordering options for working with CSV data.

## Contributing

This is a private application and contributions are not currently accepted.

## License

This project does not currently have a specified license.

## Notes

* **Customization:** If you intend to use this project, you'll likely want to adjust file paths and potentially other settings as needed to fit your environment.
