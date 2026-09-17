library(tidyverse)
library(tidycensus)

data <- iris
data2 <- iris %>% select(Sepal.Length, Sepal.Width)
