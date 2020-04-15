library(tidyverse)
library(lubridate)
library(viridis)
library(readr)
library(janitor)
library(kableExtra)
library(gganimate)
library(animation)
library(gifski)
library(jsonlite)
# library(plotly)
# library(plotly)
source('./source_crowd_data.r')
source('./source_official_data.r')
source('./source_world_data.R')

if (F) {
  dc <- build_crowd_data()
  dc_i <- dc$dc_i
  dc_raw_i <- dc$dc_raw_i  
}
dc_i_yesterday <- dc_raw_i %>% 
  filter(!(is.na(Date))) %>% 
  filter(Date >= Sys.Date()-1) %>%
  group_by(StateUt, Status) %>% 
  summarise(Total = n()) %>% 
  filter(Total > 1) %>% ungroup() 

dc_i_yesterday_district <- dc_raw_i %>% 
  filter(StateUt %in% top_n(dc_i_yesterday, 6, Total)$StateUt)  %>% 
  filter(!(is.na(Date))) %>% 
  filter(Date >= Sys.Date()-1) %>%
  group_by(StateUt, Status, District) %>% 
  summarise(Total = n()) %>% 
  filter(!(District %in% c("", NA))) %>%
  filter(Total > 4) %>%
  ungroup() 

# p <- ggplot(
#   data = dc_i_yesterday, 
#   aes(x = reorder( StateUt, Total ), 
#       y = Total, 
#       fill = reorder( StateUt, -Total )
#   )) + 
#   geom_bar(position = 'dodge', stat = 'identity') +
#   geom_text(aes(label = Total), hjust = 0, vjust = 0.5, nudge_y = 10) +
#   theme(
#     legend.position = "off",
#     panel.grid.major = element_blank(),
#     panel.background = element_blank(),
#     axis.title.x = element_blank(),
#     axis.text.y = element_text(angle = 0, hjust = 1, size = 10, face = 2),
#     axis.title.y = element_blank(),
#     axis.text.x = element_blank(),
#     axis.ticks = element_blank()
#   ) + 
#   scale_fill_viridis_d(option = 'cividis', end = 0.9) +
#   coord_cartesian(clip = "off") + 
#   coord_flip()

p <- ggplot(
  data = dc_i_yesterday_district,
  aes(x = reorder( District, Total ),
      y = Total,
      fill = reorder( District, -Total )
  )) +
  facet_wrap(~StateUt, scales = 'free_y', ncol = 1) +
  geom_bar(position = 'dodge', stat = 'identity') +
  geom_text(aes(label = Total), angle = 0, hjust = 0, vjust = 0.5, nudge_y = 2) +
  theme(
    strip.background = element_blank(),
    legend.position = "off",
    panel.grid.major = element_blank(),
    panel.background = element_blank(),
    axis.title.x = element_blank(),
    axis.text.x = element_blank(),
    axis.text.y = element_text(angle = 0, hjust = 1, size = 8, face = 1),
    axis.title.y = element_blank(),
    axis.ticks = element_blank(),
    strip.placement = "outside"
  ) +
  scale_fill_viridis_d(option = 'cividis', end = 0.9) +
  coord_cartesian(clip = "off")  + coord_flip() 


print(p)


