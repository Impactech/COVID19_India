library(tidyverse)
library(lubridate)
library(viridis)
library(readr)
library(janitor)
library(kableExtra)
library(ggmap)
# library(plotly)
source('./source_crowd_data.r')
source('./source_official_data.r')


if(F) {
  dc <- build_crowd_data()
  dc_raw_i <- dc$dc_raw_i
}

dc_district_i <- dc_raw_i %>% 
  select(District, StateUt, City) %>% 
  group_by(District, City, StateUt) %>%
  summarise(Total = n() ) %>%
  filter(!is.na(District)) %>%
  arrange(Total) %>%
  top_n(15, Total) %>%
  mutate(nrow = row_number())

p <- ggplot(data = dc_district_i, aes(x = nrow, y = 0, color = Total, size = Total)) +
  geom_point() + 
  # geom_text(aes(label = StateUt), hjust = 1, angle = -45, size = 4) +
  theme_minimal() +
  theme(
    legend.position = 'off'
  ) 

print(p)



