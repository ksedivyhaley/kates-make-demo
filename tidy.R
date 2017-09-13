library(tidyverse)

read_csv("data.csv") %>%
  gather(key = "condition", value = "Hairiness") %>%
  separate(condition, into=c("Race", "Type"), sep="-") %>%
  write_csv("tidy_data.csv")
