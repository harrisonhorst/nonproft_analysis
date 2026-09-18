library(tidyverse)
library(ggplot2)
library(usmap)

## Load Data
Nonprofits2024_Load <- read.csv("Data/Nonprofits2024.csv")

## Map number of nonprofits per state
plot_usmap(
  data = Nonprofits2024_ByState,
  values = "Count",
  color = "white",
  linewidth = 0.2
) +
  scale_fill_gradient(
    breaks = c(0, 50000, 100000, 150000),
    high = '#0072B2',
    low = 'white'
  ) +
  theme(legend.position = "top") +
  labs(fill = "Nonprofits") +
  guides(
    fill = guide_colorbar(
      barwidth = unit(5, 'cm')
    )
  )

## Map nonprofit density per state
plot_usmap(
  data = Nonprofits2024_ByState,
  value = "NPDensity",
  color = "white",
  linewidth = 0.2
) +
  scale_fill_gradient(
    breaks = c(0, 5, 10, 15),
    high = '#0072B2',
    low = 'white'
  ) +
  theme(legend.position = "top") +
  labs(fill = "Nonprofits per 1,000 people")


## Map nonprofit asset density per state
plot_usmap(
  data = Nonprofits2024_ByState,
  value = "AssetDensity",
  color = "white",
  linewidth = 0.2
) +
  scale_fill_gradient(
    breaks = c(25000, 50000, 75000),
    high = '#0072B2',
    low = 'white'
  ) +
  theme(legend.position = "top") +
  labs(fill = "Nonprofit Assets per person") +
  guides(
    fill = guide_colorbar(
      barwidth = unit(5, 'cm')
    )
  )
