library(dplyr)
library(forcats)
library(lubridate)
library(magrittr)
library(readxl)
library(stringr)

source("config.R")
source("helpers.R")

# Custom functions for data wrangling are in helpers.R

#df_dashes 10-13, 10-18, 10-23 uncertain miles, time and amt good

df_dashes <- read_excel(path = data_paths['excel_file'],
                        sheet = data_paths['dashes']) %>% 
  wrangle_dashes()

df_deliveries <- read_excel(path = data_paths['excel_file'],
                            sheet = data_paths['deliveries']) %>% 
  wrangle_deliveries()

places_summary <- df_deliveries %>% summarize_places()

weekday_summary <- summarize_weekday(df_deliveries, df_dashes)

tax_df <- df_dashes %>% taxes()

totals <- calculate_totals(df_dashes,
                           df_deliveries,
                           places_summary)

save(df_dashes, df_deliveries, places_summary, weekday_summary, tax_df, totals,
     file = data_paths['wrangled_data'])