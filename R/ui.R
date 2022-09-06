ui <- dashboardPage(

  dashboardHeader(
    title = "Postprocess CV Scans"
  ),

  dashboardSidebar(
    fileInput("file1", "Choose .xlsx/.csv files",
              multiple = TRUE,
              accept = c("text/csv",
                         "text/comma-separated-values,text/plain",
                         ".csv",
                         ".xlsx",
                         ".xls")),

    numericInput("rhe",
                 label = "RHE - V (Reversible Hydrogen Electrode - Voltage shift)",
                 value = 0.0),

    textInput("output_file",
              label = "Output file name (.zip)",
              value = "output.zip"),

    downloadButton("download",
                   label = "Download processed CV scans",
                   icon = icon("file-download"))
  ),

  dashboardBody(
    fluidRow(
      div(class = "col-sm-12 col-md-6 col-lg-4",
        box(
          width = '100%',
          title = "CV Plot",
          selectInput("selected_table",
                      label = "Select raw table to view: ",
                      selected = NULL,
                      choices = NULL),
          plotlyOutput("data_plot")
        )
      ),
      div(class = "col-sm-12 col-md-6 col-lg-8",
        box(
          width = '100%',
          title = "Data Table",
          dataTableOutput("data_table")
        )
      )
    )
  )
)
