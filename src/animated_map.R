# Purpose: Create an animated map of dashing locations
# Author: Kenneth Schackart (schackartk1@gmail.com)

# Imports -------------------------------------------------------------------

## Library calls ------------------------------------------------------------

library(dplyr)          # cleaning
library(gganimate)      # animation
library(ggmap)          # ggmap()
library(ggsn)           # Scalebar
library(gifski)         # Renderer
library(lubridate)      # hms()
library(readr)          # read_csv()
library(stringr)        # str_glue()
library(tidyr)          # pivot_*()

## File imports  -----------------------------------------------------------

source("src/config.R")  # data_paths[]
source("src/secret.R")  # api_key

locations <- read_csv(paste0(data_paths['wrangled_locations']))

# Functions -----------------------------------------------------------------

to_time <- function(t){
  hr <- t %/% 3600
  t <- t %% 3600
  min <- t %/% 60
  t <- t %% 60
  sec <- t %/% 60
  
  if(min < 10) {
    min <- paste0("0",min)
  }
  
  s <- str_glue("{hr}:{min}")
  
  s
}

add_events <- function(df){
  first_locations <- df %>% slice(1)
  first_locations$event <- "first"
  
  last_locations <- df %>% top_n(wt=time, n=1)
  last_locations$event <- "last"
  
  df$event <- "dashing"
  df <- full_join(first_locations, df)
  df <- full_join(last_locations, df)
  
  df
}


# Data cleaning -------------------------------------------------------------

map_locations <- locations %>% 
  separate(timestamp, into=c("date", "time"), sep=" ") %>% 
  rename("long" = longitude, "lat" = latitude) %>%
  #filter(date =="2021-06-07" | date=="2021-06-04") %>% 
  #filter(time > hms("17:00:00") & time < hms("18:00:00")) %>% 
  distinct(date, time, .keep_all=TRUE) %>%  # remove duplicate rows
  mutate(actual=TRUE) %>% 
  pivot_wider(names_from=date, values_from=c(lat, long, actual)) %>%
  arrange(time) %>% 
  fill(starts_with("actual"), .direction="up") %>% # rows before end of dash actual will be TRUE
  fill(-time, -starts_with("actual")) %>% # fill down missing values
  pivot_longer(cols=-time, names_to=c("dim", "date"),
               names_sep="_") %>% 
  pivot_wider(names_from=dim) %>% 
  na.omit() %>% 
  select(-actual) %>% 
  mutate(lat = lat - 0.002,
         long = long + 0.0014,
         time = hms(time)) %>% 
  group_by(date) %>% 
  add_events() 

avg_loc <- c(mean(locations$longitude), mean(locations$latitude))


# Plotting  -----------------------------------------------------------------

## Plotting objects --------------------------------------------------------- 

register_google(api_key)

map <- get_googlemap(avg_loc, zoom = 11)

anim_theme <- theme(
  axis.line=element_blank(), axis.ticks=element_blank(),
  axis.text.y=element_blank(), axis.text.x=element_blank(),
  axis.title.x=element_blank(), axis.title.y=element_blank(),
  plot.title=element_text(hjust=0.5),
  plot.subtitle=element_text(hjust=0.5),
  plot.caption=element_text(hjust=0.5),
  legend.position="none")

anim_scalebar <- scalebar(
  x.min=-110.935, x.max=-110.7, y.min=32.06, y.max=32.415,
  dist=5, dist_unit="km", location="bottomleft",
  transform=TRUE, model="WGS84", st.color="#6A6A6A",
  box.fill=c("#6A6A6A", "white"), box.color="#6A6A6A",
  border.size=0.5, st.size=3, height=0.01)

## Static plot --------------------------------------------------------------

plotted_map <- ggmap(map) +
  geom_point(data=map_locations,
             aes(x=long, y=lat,
                 group = seq_along(date),
                 color=event, size=event,
                 alpha=event)) +
  scale_color_manual(values = c("#333333", "#F5811F", "#018D97")) +
  scale_size_manual(values = c(1.75, 6, 6)) +
  scale_alpha_manual(values = c(0.75, 0.25, 0.25)) +
  anim_scalebar +
  anim_theme +
  transition_time(time) +
  labs(title="{to_time(frame_time)}",
       caption="Orange and blue flashes show clocking in and out") +
  ease_aes() +
  shadow_wake(wake_length = 0.01, alpha = 0, colour = "#CCCCCC")

## Animated plot ------------------------------------------------------------

anim <- animate(plotted_map, duration=90, fps=20,
                renderer=gifski_renderer(), 
                height=640, width=640, end_pause=20)

# Save animation ------------------------------------------------------------

anim_save(anim, filename="../data/animation.gif")


