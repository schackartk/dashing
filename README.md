# dashing
Exploring my Doordash data with R.
Disclaimer: This is not well developed for reusability, especially since data are entered manually.

## Data

Unfortunately, Doordash does not provide dashers an API for retrieving their data. So data that's available in the app must be manually recorded into an excel workbook.

Data is stored in an excel workbook with 2 sheets: "days" and "deliveries". These sheets have the following column headers in the first row:

#### Columns of "days" sheet

* `date`: *as YYYY-MM-DD*
* `time_in`: time at beginning of dash *as hh:mm* (24 hour time) 
* `time_out`: time at beginning of dash *as hh:mm* (24 hour time)
* `odo_in`: odometer reading at beginning of dash *in miles*
* `odo_out`: odometer reading at end of dash *in miles*
* `earnings`: *in dollars*
* `active_time`: time spent waiting for offers *as hh:mm*
* `dash_time`: time spent on orders *as hh:mm*
* `deliveries`: number of deliveries

#### Columns of "deliveries" sheet

* `date`: *as YYYY-MM-DD*
* `base_pay`: *in dollars*
* `peak_pay`: *in dollars*
* `tip`: *in dollars*
* `place`:

## Project Structure

```
.
├── data/                       # Data, not in repo                
├── src
│   ├── config.R                # File with paths to data, etc.
│   ├── dash_dashboard.Rmd      # Flex dashboard
│   ├── graph_tweaking.Rmd      # Playing with new plots for dashboard
│   ├── helpers.R               # Small functions for dashboard
│   ├── location_tweaking.Rmd   # Trying to incoporate Takeout location data to dashboard
│   └── style.R                 # Colors, themes for dashboard 
├── tests
│   ├── test_data.R             # Test assumptions of data structure
│   └── test_helpers.R          # Test helper functions
└── README.md
```
