library(tidyverse)
library(tidycensus)

## Start by loading in a snapshot of BMF data in January, 2024.
## This file is sourced from https://urbaninstitute.github.io/nccs/catalogs/catalog-bmf.html#monthly-bmf
Nonprofits2024_BMF_raw <- read.csv("Data_Raw/bmf_2024_01_processed.csv")

## Bring in SOI data from the IRS, with more financial detail for each oragnization that files.
## This file is sourced from https://www.irs.gov/statistics/soi-tax-stats-annual-extract-of-tax-exempt-organization-financial-data
Nonprofits2024_SOI_raw <- read.csv("Data_Raw/24eoextract990.csv")

## Bring in the state abbreviations table for later.
States <- read.csv("Data_Raw/states.csv")

Nonprofits2024_BMF <- Nonprofits2024_BMF_raw %>%
  select(
    "EIN" = "ein_raw",
    "Name" = "org_name_display",
    "Street" = "org_addr_street",
    "City" = "org_addr_city",
    "StateAbbr" = "org_addr_state",
    "ZIP" = "org_addr_zip",
    "Status" = "status_code",
    "NTEE" = "ntee_code_clean",
    "Assets" = "asset_amount",
    "Income" = "income_amount",
    "Revenue" = "revenue_amount"
  )

Nonprofits2024_SOI <- Nonprofits2024_SOI_raw %>%
  select(
    "EIN" = "EIN",
    "TaxPeriod" = "tax_pd",
    "NumEmpl" = "noemplyeesw3cnt",
    "TotRev" = "totrevenue",
    "TotFunExp" = "totfuncexpns",
    "EOYCash" = "nonintcashend",
    "EOYSavings" = "svngstempinvend",
    "EOY_AR" = "accntsrcvblend",
    "EOYAssetBldg" = "lndbldgsequipend",
    "EOYTotAsset" = "totassetsend",
    "EOYTotLiab" = "totliabend",
    "EOY_AP" = "accntspayableend",
    "EOYSecMortg" = "secrdmrtgsend",
    "EOYBondLiab" = "txexmptbndsend",
    "EOY_UNA" = "unrstrctnetasstsend",
    "EOY_TRNA" = "temprstrctnetasstsend",
    "EOY_PRNA" = "permrstrctnetasstsend",
    "TotNetAsset" = "totnetassetend"
  ) %>%
  distinct(EIN, .keep_all = TRUE)

## Now, bring in relevant census data using tidycensus packages.
ACS2024_raw <- get_acs(
  geography = "State",
  variables = c(totalpopulation = "B01003_001"),
  year = 2024,
  survey = "acs5"
)

## Join the tables.
Nonprofits2024 <- Nonprofits2024_BMF %>%
  left_join(Nonprofits2024_SOI) %>%
  left_join(States, by = join_by(x$StateAbbr == y$Abbreviation))


## Summarize and join to the ACS data.
Nonprofits2024_ByState <- Nonprofits2024 %>%
  group_by(State) %>%
  summarize(Count = n(), Assets = sum(EOYTotAsset, na.rm = TRUE)) %>%
  left_join(ACS2024_raw, by = join_by(x$State == y$NAME)) %>%
  filter(!is.na(State)) %>%
  select(-moe)

## ADD FIPS code and calculations
Nonprofits2024_Export <- Nonprofits2024_ByState %>%
  mutate(
    fips = str_pad(GEOID, width = 2, pad = "0"),
    NPDensity = (Count / estimate) * 1000,
    AssetDensity = (Assets / estimate)
  ) %>%
  filter(State != "District of Columbia")


## Export the table to the data folder.
write.csv(Nonprofits2024_Export, "Data/Nonprofits2024.csv")
