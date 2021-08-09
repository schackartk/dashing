library(dplyr)
library(magrittr)
library(readr)
library(takeout)

source('src/config.R')

load(data_paths['wrangled_data'])

locations <- json_to_tibble(f = data_paths['raw_locations']) %>%
  clean_locations() %>%
  select(timestamp, latitude, longitude)

  dash_locations <- tibble("timestamp" = c(), "latitude" = c(), "longitude" = c())

# Select data that lie between a dash start time and dash end time

for(i in seq(1:nrow(df_dashes))) {
  dash_locations <- rbind(dash_locations,
        locations[between(locations$timestamp, df_dashes$start[i], df_dashes$end[i]),])
}

# Save dash locations for import by Python

write_csv(dash_locations, file = data_paths['wrangled_locations'])