library(tidyverse)
library(ggplot2)
library(usmap)

## Load Data
Nonprofits2024_ByState <- read.csv("Data/Nonprofits2024.csv")

## ADD FIPS code
Nonprofits2024_ByState <- Nonprofits2024_ByState %>%
  mutate(fips = str_pad(GEOID, width = 2, pad = "0"))

## Chart
plot_usmap(data = Nonprofits2024_ByState, values = "Count")
