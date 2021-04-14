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