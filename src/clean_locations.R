# Purpose: Clean Takeout location data and filter to dash time
# Author: Kenneth Schackart (schackartk1@gmail.com)

# Imports -----------------------------------------------------------------

## Library calls ------------------------------------------------------------

library(dplyr)          # wrangling
library(magrittr)       # ceci n'est pas une pipe
library(readr)          # write_csv
library(takeout)        # json_to_tibble() and clean_locations()

## File imports -------------------------------------------------------------

source('src/config.R')

load(data_paths['wrangled_data'])

# Data processing -----------------------------------------------------------

## Tidying ------------------------------------------------------------------

locations <- json_to_tibble(f = data_paths['raw_locations']) %>%
  clean_locations(tz = "MST") %>%
  select(timestamp, latitude, longitude)

## Filtering ----------------------------------------------------------------

dash_locations <- tibble("timestamp" = c(), "latitude" = c(), "longitude" = c())

for(i in seq(1:nrow(df_dashes))) {
  dash_locations <- rbind(dash_locations,
        locations[between(locations$timestamp, df_dashes$start[i], df_dashes$end[i]),])
}

dash_locations$timestamp <- as.character(dash_locations$timestamp)

# Save result ---------------------------------------------------------------

write_csv(dash_locations, file = data_paths['wrangled_locations'])

