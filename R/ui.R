ui <- fluidPage(
  titlePanel("Postprocess CV Scans"),
  fileInput("file1", "Choose XLSX/CSV File",
            multiple = TRUE,
            accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv",
                       ".xlsx",
                       ".xls")),

  numericInput("rhe",
               label = "RHE - V (Reversible Hydrogen Electrode - Voltage shift)",
               value = NULL),

  actionButton("action",
               label = "Download postprocessed CV scans")
)
