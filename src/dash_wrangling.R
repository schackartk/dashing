# Purpose: Wrangle data from dash excel
# Author: Kenneth Schackart (schackartk1@gmail.com)

# Imports -----------------------------------------------------------------

## Library calls ------------------------------------------------------------

library(dplyr)          # wrangling
library(magrittr)       # %>% 
library(readxl)         # read_excel() 

## File imports -------------------------------------------------------------

source("src/config.R")  # data_paths[]
source("src/helpers.R") # wrangle_*()

# Data wrangling ------------------------------------------------------------

## Dashes -------------------------------------------------------------------

df_dashes <- read_excel(path = data_paths['excel_file'],
                        sheet = data_paths['dashes']) %>% 
  wrangle_dashes()

## Deliveries ---------------------------------------------------------------

df_deliveries <- read_excel(path = data_paths['excel_file'],
                            sheet = data_paths['deliveries']) %>% 
  wrangle_deliveries()

## Summaries ----------------------------------------------------------------

places_summary <- df_deliveries %>% summarize_places()

weekday_summary <- summarize_weekday(df_deliveries, df_dashes)

tax_df <- df_dashes %>% taxes()

totals <- calculate_totals(df_dashes,
                           df_deliveries,
                           places_summary)

## Save results -------------------------------------------------------------

save(df_dashes, df_deliveries, places_summary,
     weekday_summary, tax_df, totals,
     file = data_paths['wrangled_data'])