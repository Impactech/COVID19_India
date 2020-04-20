library(tidyverse)
library(lubridate)
library(viridis)
library(gganimate)
library(animation)
library(gifski)
library(janitor)
source('./source_crowd_data.r')

options(
  gganimate.nframes = 120, 
  gganimate.fps=8
)

animate <- T
rebuild_dataframe <- T
yesterday <- Sys.Date()-1

if (rebuild_dataframe) {
  dc <- build_crowd_data()
  dc <- dc$dc_i
}

# data_total <- dc %>% group_by(Date) %>% summarize(Total = sum(Total)) %>%
#   mutate(StateUt = "India Total") %>% ungroup()


data <-  dc %>% select(StateUt, Date, Total) %>% ungroup() %>%
  mutate(Day = as.integer(strftime(Date, format = "%j")) ) %>%
  ###
  group_by(StateUt) %>% 
  mutate( DaysSince0 = Day - min(Day)  ) %>% 
  mutate( MaxDays = max(DaysSince0) ) %>%
  ungroup() %>%
  ###
  filter(Total > 2) %>%
  mutate(label =  paste(Total, StateUt, sep=" | "))

y_max <- max(data$Total)
x_max <- max(data$DaysSince0)
x_label <- x_max + 5

labels <- data %>% 
  filter(Total > 50) %>%
  filter(Date == yesterday) %>% 
  arrange( Total ) %>% 
  mutate(yend = (y_max/n())*row_number()) %>%
  select(StateUt, yend)

data <- left_join(data, labels, by = c("StateUt") )


if (!animate) {
  data <- data %>% filter(Date == yesterday)
}

p <- ggplot(data = data, aes(x=DaysSince0, y=Total, fill = StateUt, size = Total^(0.5), color=StateUt ))  +
  geom_point(shape = 21, color = 'black', alpha=0.8) + 
  geom_line(size = 0.3, alpha=0.5)  +
  geom_label(
    aes(x=x_label, y = yend, label = label, fill=StateUt),
    color='white',
    hjust = 0, 
    size=3
    ) + 
  geom_segment(
    aes(xend = x_label, yend = yend, color = StateUt), 
    linetype = "11", 
    size=0.2, 
    alpha=0.5
    )

p <- p +
  theme_minimal() +
  theme(
    axis.text=element_text(size=8, color = "darkgrey"),
    axis.title=element_text(size=8),
    legend.position = 'off',
    plot.title = element_text(size = 10, hjust = 0),
    plot.margin = margin(15, 100, 15, 10),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank()
    ) +
  coord_cartesian(clip = 'off')  +
  scale_color_viridis_d(option="inferno", end = 0.9) + 
  scale_fill_viridis_d(option="inferno", end = 0.9) + 
  xlab("Number of day since first report") + 
  ylab("Number of cases (Cumulative)")  + 
  scale_radius(
    range = c(1, 7),
    trans = "identity",
    guide = "legend"
  )

if (animate) {
  p <- p + labs(
    title = 'Date {frame_along}', fontface = "bold"
  )
  p <- p + 
    transition_time(Date) + ease_aes('cubic-in-out') + 
    transition_reveal(Date)
    animate(
      p,
      renderer=gifski_renderer( loop = T ),
      res=150,
      height = 800,
      width = 1000,
      end_pause = 40
    )
  anim_save(paste("output", ".gif", sep="" ), animation = last_animation())
} else {
  p <- p + labs(
    title = paste('Total number of cases on ', format(Sys.Date(), "%B %d %Y") ), fontface = "bold"
  )
  print(p)
  ggsave("output.jpg", 
         width = 6.4,
         height = 3.6
         )
}



