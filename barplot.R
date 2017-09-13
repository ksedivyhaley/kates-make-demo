library(tidyverse)
library(ggplot2)

data <- read_csv("analysed_data.csv")


# Error Checking ----------------------------------------------------------


if(!is.data.frame(data)){
  stop(paste(c("data must be a data frame for analysis. Class", class(data),
               "supplied."), collapse=" "))
}
  
cols_needed <- c("Race", "Type", "mean", "sd", "p.star")
cols_missing <- !(cols_needed %in% colnames(data))
if(sum(cols_missing) > 0){
  stop(paste(c("data is missing column(s)", cols_needed[cols_missing]), 
             collapse=" "))
}
  

# Graph -------------------------------------------------------------------


above_error_bar <- max(data$sd)+0.1

ggplot(data, aes(x=Race, y=mean, fill=Race)) + 
  facet_wrap(~Type) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd),
                width=.2,
                position=position_dodge(.9)) +
  labs(title="Figure 1: Bar Plot of Hair Weight by Race and Hair Type",
       y = "Hairiness (% body weight)") + 
  geom_text(aes(label=p.star), nudge_y = above_error_bar) +
  theme(legend.position="none")  #redundant with x-axis label

ggsave("barplot.png", scale=1.2, width=6)
