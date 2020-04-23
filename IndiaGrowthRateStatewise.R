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

data <- rbind(do_i, dc_i) %>% 
  mutate(StateUt = ifelse( (StateUt %in% c('Telengana')), 'Telangana', StateUt ) ) %>%
  group_by(StateUt) %>% 
  mutate(MaxCases = max(Total)) %>% 
  ungroup() 

threshold <- min(tail(sort(unique(data$MaxCases)), 10))

data <- data %>% filter(Total >= threshold) %>%
  select(StateUt, Date, Total, Source, MaxCases) %>% 
  group_by(Date, Source, StateUt, MaxCases) %>%
  summarise( Total = sum(Total)) %>% 
  ungroup() %>%
  group_by(Source, StateUt, MaxCases) %>%
  mutate( TotalPrev = lag(Total, default = 0, order_by = Date)) %>%
  mutate( DatePrev = lag(Date, order_by = Date) ) %>% 
  mutate( DateCurPrev = as.integer(Date - DatePrev) ) %>%
  # filter( Date > ymd('2020-03-01')	) %>%
  filter( Date < Sys.Date() ) %>% 
  mutate( DailyRate = round((Total - TotalPrev)*100/(DateCurPrev*TotalPrev) ) ) %>%
  ungroup() %>%
  mutate(Series = paste(StateUt, Source, sep = "|"))
  

plot_theme <- theme(
  axis.text=element_text(size=8, color = "darkgrey"), 
  axis.title=element_text(size=10),
  plot.title = element_text(size = 12, hjust = 0),
  panel.grid.minor = element_blank(),
  panel.grid.major = element_blank(),
  # axis.line.y = element_blank(),
  # axis.text.y = element_blank(),
  axis.ticks = element_blank(),
  legend.position = "off",
  legend.title = element_blank(),
  panel.background = element_rect(fill = "white")
) 

p1 <- ggplot(data = data,  aes(x = StateUt, y = DailyRate, fill=reorder(StateUt, MaxCases))) + 
  plot_theme +
  # facet_wrap(~StateUt, ncol=1) +
  # geom_point(alpha = 1, size = 1) + 
  # geom_line(linetype = '11', alpha = 1) + 
  # geom_smooth(alpha = 0.2, size=0.6, se = F) +
  # geom_density(stat = 'count') +
  geom_violin(trim = T, draw_quantiles = c(0.1, 0.5, 0.8)) +
  labs(y = "Growth rate in Percentage") + 
  # ylim(c(0, 50)) +
  # geom_label( color = "white", fill="black",
  #             x=dmy('06-03-2020'), 
  #             y=40, alpha=0.5, hjust=0,
  #             label= paste("Yesterdays Rate = ", round( tail(data$DailyRate, n=2)[1] ), "%", sep = "") 
  # ) +
  scale_fill_viridis_d(end = 1) + scale_color_viridis_d(end = 1) + coord_flip()

print(p1)
