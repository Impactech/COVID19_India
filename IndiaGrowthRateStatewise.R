library(tidyverse)
library(lubridate)
library(viridis)
library(readr)
library(janitor)
source('./source_crowd_data.r')
source('./source_official_data.r')

pal <- "cividis"
rebuild_crowdsource_dataframe <- F
rebuild_official_dataframe <- F

if (rebuild_crowdsource_dataframe) {
  dc <- build_crowd_data()
  dc_i <- dc$dc_i %>% ungroup()
}

if (rebuild_official_dataframe) {
  do_i <- build_official_data() %>% ungroup()
}

d <- rbind(do_i, dc_i) %>% 
  mutate(StateUt = ifelse( (StateUt %in% c('Telengana')), 'Telangana', StateUt ) ) %>%
  group_by(StateUt, Source) %>% 
  mutate(MaxCases = max(Total)) %>% 
  filter(Date >= dmy('25-03-2020')) %>%
  filter(Source == 'Ministry of Health and Family Welfare') %>%
  ungroup() 

threshold <- min(tail(sort(unique(d$MaxCases)), 5))

data <- d %>% 
  filter(MaxCases >= threshold) %>%
  select(StateUt, Date, Total, Source, MaxCases) %>% 
  group_by(Date, Source, StateUt, MaxCases) %>%
  summarise( Total = sum(Total)) %>% 
  ungroup() %>%
  group_by(Source, StateUt, MaxCases) %>%
  mutate( TotalPrev = lag(Total, default = 0, order_by = Date)) %>%
  mutate( DatePrev = lag(Date, order_by = Date) ) %>% 
  mutate( DateCurPrev = as.integer(Date - DatePrev) ) %>%
  mutate( DailyRate = round((Total - TotalPrev)*100/(DateCurPrev*TotalPrev) ) ) %>%
  mutate( NewCases = (Total - TotalPrev) ) %>%
  ungroup() %>%
  select(-c(Total, TotalPrev, DatePrev, DateCurPrev)) %>%
  pivot_longer(-c(Date, Source, StateUt, MaxCases), names_to = 'Metric') %>%
  mutate(Series = paste(StateUt, MaxCases, sep = ' | '))
  

p1 <- ggplot(data = data,  aes(x = Date, y = value, color=reorder(Series, -MaxCases))) + 
  facet_wrap(~Metric, ncol=1, scales = 'free_y') +
  geom_smooth(size=1.2, alpha = 0.2 , se = F) + 
  theme_minimal() +
  theme(
    legend.title = element_blank(), 
    axis.title = element_blank(),
    axis.text.x = element_text(angle = 30),
    strip.text = element_text(hjust = 0)
  )

print(p1)
