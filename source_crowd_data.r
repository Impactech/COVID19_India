library(jsonlite)
build_crowd_data <- function () {
  url <- "https://api.covid19india.org/raw_data.json"
  json <- fromJSON(txt=url)
  dc <- json$raw_data %>% clean_names() %>%
    select(-c("source1", "source2", "source3", "backupnotes", "notes", "estimatedonsetdate")) %>%
    filter(! is.na(dateannounced) ) %>%
    mutate(Date = dmy(dateannounced)) %>%
    select(Date, detectedstate, detectedcity, detecteddistrict, agebracket, currentstatus) %>%
    rename(
      StateUt = "detectedstate",
      District = "detecteddistrict",
      City = "detectedcity",
      Status = "currentstatus", 
      AgeBracket = "agebracket"
      ) %>%
    arrange(Date)
  dtcs <- NULL
  for (di in as.list( unique(dc$Date) )) {
    print(di)
    dts <- dc %>%
      filter(Date <= di) %>% group_by(StateUt, Status) %>%
      summarize(total = n() ) %>% mutate(Date = di, Source = 'Crowd Source')
    dtcs <- rbind(dtcs, dts)
  }
  dtc <- dtcs %>% filter(!(Status %in% c("", NA, "NA")) )%>%
    pivot_wider(names_from = Status, values_from = total, values_fill = list(total = 0)) %>%
    mutate(Total = Recovered + Hospitalized + Deceased + Migrated) %>% select(-c(Migrated))
  cs_data_list <- list(dc_i = dtc, dc_raw_i = dc)
  return(cs_data_list)
}