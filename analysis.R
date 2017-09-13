library(tidyverse)
library(broom)

data <- read_csv("tidy_data.csv")


# Error Checking ----------------------------------------------------------


if(!is.data.frame(data)){
  stop(paste(c("data must be a data frame for analysis. Class", class(data),
               "supplied."), collapse=" "))
}

cols_needed <- c("Race", "Type")
cols_missing <- !(cols_needed %in% colnames(data))
if(sum(cols_missing) > 0){
  stop(paste(c("data is missing column(s)", 
               cols_needed[cols_missing]), collapse=" "))
}


# Define p-value to p-star translation ------------------------------------


get_pstar <- function(pval) {
  
  if (!is.numeric(pval)){
    stop("p-value must be numeric. Value of class ", class(pval), " supplied.")
  }
  if (pval > 1 | pval < 0){
    stop("p-value must be between 0 and 1. Value ", pval, " supplied.")
  }
  
  breaks <- c(0, 0.001, 0.01, 0.05, 1)
  labels <- c("***", "**", "*", "")
  cut(pval, breaks, labels)
}
  

# Data Analysis -----------------------------------------------------------

nested_data <- data %>%
  group_by(Race, Type) %>%
  nest()
  
#This allows me to join a copy of this ctrl data to my main tibble
human <- nested_data %>%
  filter(Race=="Human") %>%
  select(-Race) #Redundant - it's all Human
  
analysed_data <- nested_data %>%
  inner_join(human, by="Type") %>%
  rename(data = data.x,
         human_data = data.y) %>%  # refer to in t.test()
  mutate(data = map(data, `[[`, 1), # produces vectors for t.test()
         human_data = map(human_data, `[[`, 1),
         human_mean = map_dbl(human_data, mean, na.rm = TRUE),
         mean = map_dbl(data, mean, na.rm = TRUE),
         sd = map_dbl(data, sd, na.rm = TRUE), 
         diff = mean-human_mean,
         test = map2(data, human_data, t.test),
         tidy = map(test, tidy)) %>%
  unnest(tidy) %>%
  select(Race, Type, mean, sd, diff, p.value) %>%
  mutate(p.star = sapply(p.value, get_pstar))

write_csv(analysed_data, "analysed_data.csv")
