library(jsonlite)
build_crowd_data <- function () {
  d1 <- read_csv('http://api.covid19india.org/csv/latest/raw_data1.csv')
  d2 <- read_csv('http://api.covid19india.org/csv/latest/raw_data2.csv')
  d3 <- read_csv('http://api.covid19india.org/csv/latest/raw_data3.csv')
  clm <- intersect(intersect(colnames(d1), colnames(d2) ), colnames(d3) )
  d1 <- d1 %>% select(clm)
  d2 <- d2 %>% select(clm)
  d3 <- d3 %>% select(clm)
  dc <- rbind(d1, d2, d3) %>% clean_names() %>%
    select(-c("source_1", "source_2", "source_3", 
              "notes", "contracted_from_which_patient_suspected", 
              "nationality", "type_of_transmission",
              "status_change_date", "state_patient_number", "state_code")) %>%
    filter(! is.na(date_announced) ) %>%
    mutate(date_announced = dmy(date_announced)) %>%
    rename(
      Date = "date_announced",
      StateUt = "detected_state",
      District = "detected_district",
      City = "detected_city",
      Status = "current_status", 
      AgeBracket = "age_bracket"
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