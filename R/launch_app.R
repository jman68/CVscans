#' Launches ShinyApp
#'
#' @return initializes Shiny App
#'
#' @export
launch_app <- function() {
  library(CVscans)
  options(shiny.autoload.r=FALSE)
  shinyApp(ui = ui, server = server)
}
