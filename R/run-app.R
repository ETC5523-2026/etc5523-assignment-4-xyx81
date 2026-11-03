#' Launch the quarantine scenario explorer
#'
#' Open the Shiny app for comparing published quarantine
#' simulation scenarios.
#'
#' @return Runs the Shiny application.
#' @importFrom bslib page_sidebar
#' @importFrom ggplot2 ggplot
#' @export
#' @examples
#' \dontrun{
#' run_app()
#' }
run_app <- function() {
  app_dir <- system.file("app", package = "dataexplorer")
  shiny::runApp(appDir = app_dir)
}