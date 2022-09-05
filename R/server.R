server <- function(input, output, session) {
  observeEvent(input$action, {
    req(input$file1)
    req(input$rhe)

    for(file in input$file1$datapath) {
      preworkup = readxl::read_excel(file)
      postworkup = cv_postprocess(preworkup, input$rhe)
      writexl::write_xlsx(postworkup, file)
    }
  })
}
