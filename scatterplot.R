library(tidyverse)
library(ggplot2)

## @knitr scatterplot

data <- read_csv("tidy_data.csv")

#check to make sure I've read in a tidy data frame
if(!is.data.frame(data)){
  stop(paste(c("analysed_data must be a data frame for graphing. Class", 
               class(df), "supplied."), collapse=" "))
}
cols_needed <- c("Race", "Type", "Hairiness")
cols_missing <- !(cols_needed %in% colnames(data))
if(sum(cols_missing) > 0){
  stop(paste(c("analysed_data is missing column(s)", 
               cols_needed[cols_missing]), collapse=" "))
}

ggplot(data, aes(x=Race, y=Hairiness, color=Race)) + 
  facet_wrap(~Type) +
  geom_jitter() +
  labs(title="Figure 2: Scatterplot of Hair Weight by Race & Hair Type", 
       y = "Hairiness (% body weight)") + 
  theme(legend.position="none")  #redundant with x-axis label
  