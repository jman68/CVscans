library(dplyr)
library(tidyr)
library(zip)
library(ggplot2)
library(plotly)

cv_postprocess <- function(pre_workup,
                           rhe) {

  # extract number of scans - subtracting entries from scan 1
  scan1 <- pre_workup %>%
    filter(Scan == 1) %>%
    select(Index) %>%
    max()

  n_scans <- max(pre_workup$Scan) - 1
  n_index <- (max(pre_workup$Index) - scan1)/n_scans

  # filter scans to exclude scan 1
  pre <- pre_workup %>%
    filter(Scan != 1)

  # reset index by scan number and set potential (V vs RHE)
  pre1 <- pre %>%
    mutate(`Potential (V vs RHE)` = `Potential applied (V)` + rhe) %>%
    relocate(`Potential applied (V)`, `Potential (V vs RHE)`)
  pre1$Index <- rep.int(1:n_index, n_scans)

  # select relevant columns and spread and rename scan columns
  pre2 <- pre1 %>%
    select(`Potential applied (V)`, `Potential (V vs RHE)`, `WE(1).Current (A)`, Scan, Index) %>%
    spread(Scan, `WE(1).Current (A)`) %>%
    rename_at(vars(-(1:3)), ~ paste0("Scan ", .)) %>%
    arrange(Index)

  # get average of scans 2 through n and drop index
  scan_list <- names(pre2)[grepl("Scan", names(pre2))]
  pre3 <- pre2 %>%
    mutate(Average = rowMeans(select(., all_of(scan_list)))) %>%
    mutate(uA = Average * 1000000) %>%
    select(-Index)

  # return output
  return(pre3)
}


plot_cv <- function(df,
                    rhe) {

  # pre-process data
  df1 <- df %>%
    filter(Scan != 1) %>%
    mutate(`Potential (V vs RHE)` = `Potential applied (V)` + rhe,
           Scan = as.character(Scan)) %>%
    relocate(`Potential applied (V)`, `Potential (V vs RHE)`)

  # plotly wrapper of geom_path to get continuous CV curve
  plotly::ggplotly(
    ggplot2::ggplot(data = df1) +
      geom_path(aes(`Potential (V vs RHE)`, `WE(1).Current (A)`, color = Scan), size=0.1) +
      labs(title = "CV Plot", x = "Potential (V vs RHE)", y = "Current (A)")
  )
}

