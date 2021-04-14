#' Add a dollar sign to a string
#'
#' @param stri A string representing a dollar amount
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
                   levels = c("Sunday", "Monday", "Tuesday",
                              "Wednesday", "Thursday", "Friday",
                              "Saturday"))
  
  df
}

#' Create summary dataframe by merchant
#'
#' @param df 
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