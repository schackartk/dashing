#' Add a dollar sign to a string
#'
#' @param stri A dollar amount
#'
#' @return
#' @export
as_dollar <- function(stri) {
  paste0("$", stri)
}

#' Convert a string from hh:mm to lubridate hour
#'
#' @param stri 
#'
#' @return
#' @export
as_hour <- function(stri) {
  stri %>% paste0(":00") %>% 
    hms() %>% 
    as.duration() %>% 
    as.numeric("hours")
}

days_of_wk <- c("Sunday", "Monday", "Tuesday",
                "Wednesday", "Thursday", "Friday",
                "Saturday")

#' Wrangle dashes dataframe
#'
#' @param df 
#'
#' @return
#' @export
wrangle_dashes <- function(df) {
  df <- df %>%
    dplyr::mutate(
      day = weekdays(as.Date(df$date)),
      .after = date)
  
  df$day <- factor(df$day,
                   levels = days_of_wk)
  
  df <- df %>% dplyr::mutate(
    start = lubridate::ymd_hm(paste(df$date,
                                    df$time_in),
                              tz = "MST"),
    end = lubridate::ymd_hm(paste(df$date,
                                  df$time_out),
                            tz = "MST"),
    total_time = round(as.numeric(difftime(end,
                                           start,
                                           units = "hours")),
                       digits = 2),
    active_hr = as_hour(active_time),
    dash_hr = as_hour(dash_time))
  
  df <- df %>%
    dplyr::mutate(miles = odo_out - odo_in,
                  .after = odo_out) %>% 
    dplyr::mutate(per_mi = round(earnings / miles, 2),
                  per_trip = round(earnings / deliveries, 2),
                  per_hour = round(earnings / total_time, 2),
                  .after = earnings)
  
  df
}

#' Wrangle deliveries dataframe
#'
#' @param df 
#'
#' @return
#' @export
wrangle_deliveries <- function(df) {
  df <- df %>% 
    mutate(total = base_pay + tip + peak_pay,
           .after = tip,
           day = weekdays(as.Date(df$date)))
  
  df$day <- factor(df$day,
                   levels = days_of_wk)
  
  df
}

#' Create summary dataframe by merchant
#'
#' @param df df_deliveries
#'
#' @return
#' @export
summarize_places <- function(df) {
  df %>% dplyr::group_by(place) %>% 
    dplyr::summarize(count = n(),
                     mean_base = mean(base_pay) %>% round(digits = 2),
                     mean_tip = mean(tip) %>% round(digits = 2),
                     mean_total = mean(total) %>% round(digits = 2)) %>% 
    dplyr::filter(!is.na(place))
}

#' Create summary dataframe by day of the week
#'
#' @param df_deliveries 
#' @param df_dashes 
#'
#' @return
#' @export
summarize_weekday <- function(df_deliveries, df_dashes) {
  df_deliveries %>%
    dplyr::group_by(day) %>% 
    dplyr::filter(!is.na(place)) %>% 
    dplyr::summarize(delivery_count = n(),
                     mean_base = mean(base_pay) %>% round(digits = 2),
                     mean_tip = mean(tip) %>% round(digits = 2),
                     mean_total = mean(total) %>% round(digits = 2)) %>% 
    tibble::add_column(df_dashes %>%
                         dplyr::group_by(day) %>%
                         dplyr::summarize(money = sum(earnings),
                                          time = sum(total_time)) %>%
                         dplyr::transmute(hourly = round(money/time,
                                                         digits = 2))) %>% 
    tibble::add_column(df_dashes %>%
                         dplyr::group_by(day) %>% 
                         dplyr::summarize(count = n()) %>% 
                         select(count),
                       .after = "day")
}

#' Estimate taxes
#'
#' @param df df_dashes
#' @param rate 
#'
#' @return
#' @export
taxes <- function(df, rate = 0.3) {
  df %>% dplyr::select(date, miles, earnings) %>% 
    dplyr::filter(date > as_date("2020-10-23")) %>% 
    dplyr::mutate(deduction = dplyr::case_when(
      year(date) == 2020 ~ (miles * 0.575),
      year(date) == 2021 ~ (miles * 0.56)),
      taxable = earnings - deduction,
      taxes = dplyr::case_when(
        taxable > 0 ~ round(rate * taxable, digits = 2),
        taxable <= 0 ~ 0),
      net = earnings - taxes)
}

#' Calculate totals
#'
#' @param df_dashes # from wrangle_dashes()
#' @param df_deliveries # from wrangle_deliveries()
#'
#' @return
#' @export
calculate_totals <- function(df_dashes, df_deliveries, places_summary) {
  
  totals <- c()
  
  # Totals that cannot be cross-checked
  
  totals['miles'] <-  sum(df_dashes$miles)
  totals['places'] <-  places_summary %>% n_distinct()
  totals['dashes'] <- df_dashes %>% nrow()
  totals['tips'] <- sum(df_deliveries$tip)
  totals['base'] <- sum(df_deliveries$base_pay)
  totals['peak'] <- sum(df_deliveries$peak_pay)
  totals['time'] <- sum(df_dashes$total_time)
  totals['active'] <- sum(df_dashes$active_hr)
  totals['idle'] <- totals['time'] - totals['active']
  
  # Totals that need to be cross-checked
  
  # Total number of deliveries
  
  deliveries_1 <- df_deliveries %>% filter(!is.na(place)) %>% nrow()
  deliveries_2 <-  sum(df_dashes$deliveries)
  
  if (deliveries_1 != deliveries_2)
    warning("Lifetime number of deliveries does not match.")
  
  totals['deliveries'] <-  deliveries_1
    
  
  # Total earnings
  
  earnings_1 <- sum(df_deliveries$total)
  earnings_2 <- sum(df_dashes$earnings)
  
  if (earnings_1 != earnings_2)
    warning("Lifetime earnings does not match")

  totals['earnings'] <-  earnings_1
  
  
  return(totals)
  
}