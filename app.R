# Launch the ShinyApp
source(file.path(getwd(), "R/data_processing_fn.R"))
shinyApp(ui = ui, server = server)
