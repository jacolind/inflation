## library 

library(WDI)
library(readr)
library(tibble)
library(dplyr)
library(tidyr)
library(ggplot2)
library(knitr)
library(Quandl)
library(xts)


## find indicators 

# money 
WDIsearch('broad money')
WDIsearch('M1')
WDIsearch('M2')
WDIsearch('M2')[c(6,10), ]
in_money <- WDIsearch('M2')[5, ]
df_money_error <- WDI(countries, 
                in_money[[1]], 
                startyear, endyear)

names(df_money) <- gsub(" ", "_", names(df_money))
df_money <- df_money %>%
  rename(country = Country_Name, 
         iso2c = Country_Code) %>%
  select(-Indicator_Name, -Indicator_Code, -X63) %>%
  gather(key=year, value=broadmoney, -country, -iso2c) %>%
  mutate(year = as.numeric(year))

# debt 
WDIsearch('government debt')
in_gov_d <- WDIsearch('government debt')[8,]

# consumption 
WDIsearch('government consumption')
in_gov_c <- WDIsearch('government consumption')[1,]
in_gov_c[["name"]] # the only one which was not depreciated

# private income 

# gdp or gni 
WDIsearch('GNI')[c(4,24,30,36),]
WDIsearch('GDP')
in_gdp <- WDIsearch('GDP')[82,]
in_gni <- WDIsearch('GNI')[24,]

# saving 
WDIsearch("saving")[c(25,38),]

# inflation
WDIsearch('inflation')
in_infl <- WDIsearch('inflation')[1,] 

## chose indicators 

in_money
in_gov_d
in_gov_c
in_gdp
in_gni
in_infl

indicators <- c( 
                in_gov_d[[1]], 
                in_gov_c[[1]],
                in_gdp[[1]],
                in_gni[[1]],
                in_infl[[1]])

indicator_names <- c( 
                     "gov_d_pogdp",
                     "gov_c_clcu",
                     "gdp",
                     "gni",
                     "infl"
                     )
## read 

# must download manually for some reason because it does not exist in API 
df_money <- read_csv("data/API_FM.LBL.BMNY.GD.ZS_DS2_en_csv_v2_10137988.csv", 
                     skip = 3)
# https://data.worldbank.org/indicator/FM.LBL.BMNY.GD.ZS?view=chart

df <- WDI(countries, indicators, startyear, endyear)
df <- as_tibble(df)

## clean 

names(df)[1:3]
stopifnot(length(names(df)[4:dim(df)[2]]) == length(indicator_names))
names(df)[4:dim(df)[2]] <- indicator_names
names(df)
df$iso2c[1:100]

df <- df %>%
  filter(iso2c %not in% non_countries) %>%
  mutate(iso2c = ifelse(iso2c == "", NA, iso2c)) %>%
  filter(!is.na(iso2c))
glimpse(df)

## merge 

names(df)
names(df_money)

df$key <- paste(df$iso2c, as.character(df$year), sep="_")
df_money$key <- paste(df_money$iso2c, as.character(df_money$year), sep="_")

df_money_2 <- df_money %>%
  filter(iso2c %not in% non_countries) %>%
  mutate(iso2c = ifelse(iso2c == "", NA, iso2c)) %>%
  filter(!is.na(iso2c))

df2 <- df %>%
  filter(iso2c %not in% non_countries) %>%
  mutate(iso2c = ifelse(iso2c == "", NA, iso2c)) %>%
  filter(!is.na(iso2c)) %>%
  merge(df_money_2, on="key")

############################# error with merge ################################

## see 

plotinf("United States", data=df)

df %>%
  filter(country == "United States") %>%
  ggplot(aes(year, gov_cons_LCU)) + 
  geom_point() +
  geom_smooth()

df %>%
  group_by(country) %>%
  filter(!is.na(gov_cons_LCU)) %>%
  arrange(desc(gdp)) %>%
  distinct()

df %>%
  filter(country == "Sweden")
