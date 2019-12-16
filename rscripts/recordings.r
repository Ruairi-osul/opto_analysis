library(tidyverse)
library(feather)


pathr <- file.path("data", "recordings.feather")
dfr <- read_feather(pathr) %>%
  mutate_if(is.character, as.factor) %>%
  mutate(recording_session_id = as.factor(recording_session_id))

pathn <- file.path("data", "neurons.feather")
dfn <- read_feather(pathn) %>%
  mutate_if(is.character, as.factor) %>%
  mutate(recording_session_id = as.factor(recording_session_id))

fig_dir <- file.path("figs")

dfn %>%
  head()

theme_Publication <- function(base_size=14, base_family="helvetica") {
  library(grid)
  library(ggthemes)
  (theme_foundation(base_size=base_size, base_family=base_family)
    + theme(plot.title = element_text(face = "bold",
                                      size = rel(1.2), hjust = 0.5),
            text = element_text(),
            panel.background = element_rect(colour = NA),
            plot.background = element_rect(colour = NA),
            panel.border = element_rect(colour = NA),
            axis.title = element_text(face = "bold",size = rel(1)),
            axis.title.y = element_text(angle=90,vjust =2),
            axis.title.x = element_text(vjust = -0.2),
            axis.text = element_text(), 
            axis.line = element_line(colour="black"),
            axis.ticks = element_line(),
            panel.grid.major = element_line(colour="#f0f0f0"),
            panel.grid.minor = element_blank(),
            legend.key = element_rect(colour = NA),
            legend.position = "bottom",
            legend.direction = "horizontal",
            legend.key.size= unit(0.2, "cm"),
            legend.margin = unit(0, "cm"),
            legend.title = element_text(face="italic"),
            plot.margin=unit(c(10,5,5,5),"mm"),
            strip.background=element_rect(colour="#f0f0f0",fill="#f0f0f0"),
            strip.text = element_text(face="bold")
    ))
  
}

scale_fill_Publication <- function(...){
  library(scales)
  discrete_scale("fill","Publication",manual_pal(values = c("#386cb0","#fdb462","#7fc97f","#ef3b2c","#662506","#a6cee3","#fb9a99","#984ea3","#ffff33")), ...)
  
}

scale_colour_Publication <- function(...){
  library(scales)
  discrete_scale("colour","Publication",manual_pal(values = c("#386cb0","#fdb462","#7fc97f","#ef3b2c","#662506","#a6cee3","#fb9a99","#984ea3","#ffff33")), ...)
  
}



dfn %>%
  ggplot(aes(fill=fct_infreq(recording_session_id), x=group_name)) +
  geom_bar(position=position_dodge2(width=1.001)) +
  coord_flip() +
  theme_Publication() +
  labs(title="",
       y="Number of neurons recorded",
       x="Individual Recordings") +
  theme(legend.position = "none") +
  ggsave(file.path(fig_dir, "neurons_x_recordings.png"))



