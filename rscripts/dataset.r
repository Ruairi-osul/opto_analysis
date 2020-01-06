library(tidyverse)
library(feather)

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
            legend.spacing = unit(0, "cm"),
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

fig_dir <- file.path("figs")

pathn <- file.path("data", "neurons.feather")
dfn <- read_feather(pathn) %>%
  mutate_if(is.character, as.factor) %>%
  mutate(recording_session_id = as.factor(recording_session_id))

pathr <- file.path("data", "recordings.feather")
dfr <- read_feather(pathr) %>%
  mutate_if(is.character, as.factor) %>%
  mutate(session_name = as.factor(session_name))


dfr %>%
  ggplot(aes(x=group_name)) +
  geom_bar() +
  scale_fill_Publication() +
  theme_Publication() +
  labs(x="Group", y="Number of Recording Sessions") +
  ggsave(file.path(fig_dir, "session_count_x_group.png"))

dfn %>%
  group_by(session_name) %>%
  summarise(n=n()) %>%
  left_join(distinct(select(dfn, session_name, group_name))) %>%
  ggplot(aes(x=group_name, y=n, color=group_name)) +
    geom_jitter(width=0.25, size=3.5, alpha=0.7) +
    theme_Publication() +
    ylim(0, 100) +
    scale_colour_Publication() +
    labs(y="Number of Neurons Recorded Per Session",
         x="Group") +
  ggsave(file.path(fig_dir, "neurons_per_session_x_group.png"))
