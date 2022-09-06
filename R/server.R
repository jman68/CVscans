server <- function(input, output, session) {

  # observers
  observe({
    req(!is.null(input$file1))
    choices = input$file1$name
    updateSelectInput(session,
                      "selected_table",
                      choices = choices)
  })

  # reactive values
  df <- reactive({
    req(!is.null(input$file1))
    req(!is.null(input$selected_table))
    req(input$selected_table != "")

    df_paths = input$file1
    df = df_paths %>%
      filter(name == input$selected_table)
    readxl::read_excel(df$datapath)
  })

  # outputs
  output$download <- downloadHandler(

    filename = function(){
      if(!grepl(".", input$output_file)) {
        paste0(input$output_file, ".zip")
      } else {
        output_file = unlist(strsplit(input$output_file, "\\."))[1]
        paste0(output_file, ".zip")
      }
    },
    content = function(file){

      # use temp dir to avoid permission issues
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      files = NULL

      for(i in 1:nrow(input$file1)) {
        datapath = input$file1$datapath[i]
        if(grepl("xlsx", datapath)) {
          preworkup = readxl::read_excel(datapath)
        } else if(grepl("csv", datapath)) {
          preworkup = read.csv(datapath)
        }

        tryCatch(
          {
            postworkup = cv_postprocess(preworkup, input$rhe)
            filename = input$file1$name[i]
            writexl::write_xlsx(postworkup, path = filename)
            files = c(filename, files)
          },
          error = function(cond) {
            print("CV Data could not be processed!")
          }
        )
      }
      zip::zip(file, files)
    },
    contentType = "application/zip"
  )

  output$data_table <- renderDataTable(
    df(),
    options = list(scrollX = TRUE,
                   searching = FALSE,
                   lengthMenu = list(c(10,25,50,-1), c('10','25','50','All')),
                   pageLength = 10
                   )
  )

  output$data_plot <- renderPlotly({
    req(!is.null(df()))
    plot_cv(df(), input$rhe)
  })
}

