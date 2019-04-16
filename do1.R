## library 

library(WDI)
library(readr)
library(tibble)
library(dplyr)
library(tidyr)
library(ggplot2)
library(knitr)

## pick indicators and years 

countries <- "all"

startyear <- 1990
endyear <- 2018

WDIsearch(string='inflation', field='name')
WDIsearch(string='FP.CPI.TOTL.ZG', field='indicator')
indic_inflation <- "FP.CPI.TOTL.ZG" # cpi 

WDIsearch(string='gdp per capita')
WDIsearch(string='gdp')
WDIsearch('gdp.*capita.*constant')
indic_gdp <-  "NY.GDP.MKTP.CD" # "GDP (current US$)"
indic_gdp_pcap <- "NY.GDP.PCAP.CD" # "GDP per capita (current US$)"

## import 

dfn <- WDI(countries, indic_inflation, startyear, endyear)
dfgdp <- WDI(countries, indic_gdp, startyear, endyear)
dfpcgdp <- WDI(countries, indic_gdp_pcap, startyear, endyear)

dfn <- as_tibble(dfn)
dfgdp <- as_tibble(dfgdp)
dfpcgdp <- as_tibble(dfpcgdp)

## see 

df %>%
  select(iso2c, country) %>%
  summarise(length(unique(iso2c)), 
            length(unique(country)))

## check 

# same nr of countries
stopifnot(length(unique(dfpcgdp$iso2c)) == length(unique(dfgdp$iso2c)))
stopifnot(length(unique(dfpcgdp$iso2c)) == length(unique(dfn$iso2c)))

## merge 

str(dfn)
str(dfgdp)
str(dfpcgdp)

df <- dfn %>%
  merge(dfgdp, on="iso2c") %>%
  merge(dfpcgdp, on="iso2c") %>%
  as_tibble() %>%
  rename(inflation = FP.CPI.TOTL.ZG,
         gdp = NY.GDP.MKTP.CD,
         pc_gdp = NY.GDP.PCAP.CD
         ) %>%
  mutate(pop = gdp / pc_gdp)


## remove non countries 

# all cuntry codes 
unique(dfpcgdp$iso2c)

# function 
iso_to_country <- function(isocode, data){
  data %>%
    filter(iso2c %in% isocode) %>%
    select(iso2c, country) %>%
    distinct()
}

# create list of iso & country pair
iso_to_country("AD", dfgdp)
all_iso <- unique(dfgdp$iso2c)
all_iso_cntr <- iso_to_country(all_iso, dfpcgdp)
all_iso_cntr <- as.data.frame(all_iso_cntr)

# select non countries 
all_iso_cntr
non_countries <- all_iso_cntr$iso2c[1:47] 

# remove non countries 
`%not in%` <- function (x, table) is.na(match(x, table, nomatch=NA_integer_))
df <- df %>%
  filter(iso2c %not in% non_countries) %>%
  arrange(iso2c)

df

saveRDS(df, file = "data/df.R")

