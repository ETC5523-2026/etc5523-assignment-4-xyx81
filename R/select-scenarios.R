#' Select quarantine simulation scenarios
#'
#' Selects scenarios for specified reproduction numbers and a minimum
#' vaccine efficacy. Results are ordered by reproduction number and
#' vaccine efficacy.
#'
#' @param data A data frame containing the numeric columns
#'   `r0`, `vaccine_efficacy` and `relative_pressure`.
#' @param r0_values A numeric vector of reproduction numbers to retain.
#'   Defaults to all published values from 1 to 10.
#' @param min_efficacy A single number between 0 and 0.9.
#'   Scenarios with vaccine efficacy equal to or above this value
#'   are retained. Defaults to 0.
#' @return A data frame containing the selected scenarios.
#'   Returns zero rows when no scenarios match.
#' @examples
#' select_scenarios(
#'   quarantine_scenarios,
#'   r0_values = c(3, 6),
#'   min_efficacy = 0.5
#' )
#' @export
select_scenarios <- function(data,
                             r0_values = 1:10,
                             min_efficacy = 0) {
  if (!is.numeric(min_efficacy) ||
      length(min_efficacy) != 1 ||
      is.na(min_efficacy) ||
      !is.finite(min_efficacy) ||
      min_efficacy < 0 ||
      min_efficacy > 0.9) {
    stop("min_efficacy must be one number between 0 and 0.9.")
  }
  
  selected <- dplyr::filter(
    data,
    data[["r0"]] %in% r0_values,
    data[["vaccine_efficacy"]] >= min_efficacy
  )
  
  selected[
    order(selected[["r0"]], selected[["vaccine_efficacy"]]),
    ,
    drop = FALSE
  ]
}