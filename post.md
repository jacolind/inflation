---
date: 2018-10-12
---

42 countries have a historical inflation rate above 8%. The sum of these countries GDP in 2017 was USD 6,719,239 million - this is 35% of the United States' GDP.

Historical inflation is calculated as the average CPI between 2000 and 2017.

The table below shows the inflation rate, along with GDP numbers and sample size. The two GDP columns can be used to gauge the size of each economy. The reason for the sample size `n` to be less than 17 is if the inflation rate is NA. Data comes from the World bank. 



|country               | Inflation (1999-2017 average)| GDP as % of US| GDP mUSD in 2017|  n|
|:---------------------|-----------------------------:|--------------:|----------------:|--:|
|Zimbabwe              |                        1786.9|            0.1|            17846| 15|
|South Sudan           |                          87.8|            0.0|             2904|  6|
|Congo, Dem. Rep.      |                          73.4|            0.2|            37241| 14|
|Angola                |                          53.1|            0.6|           124209| 17|
|Belarus               |                          32.6|            0.3|            54442| 17|
|Venezuela, RB         |                          25.9|            2.5|           482359| 15|
|Serbia                |                          17.5|            0.2|            41432| 17|
|Iran, Islamic Rep.    |                          17.1|            2.3|           439514| 17|
|Turkey                |                          17.1|            4.4|           851102| 17|
|Guinea                |                          16.8|            0.1|            10496| 12|
|Suriname              |                          16.6|            0.0|             3324| 17|
|Ghana                 |                          16.2|            0.2|            47330| 17|
|Malawi                |                          16.1|            0.0|             6303| 17|
|Sudan                 |                          15.3|            0.6|           117488| 17|
|Myanmar               |                          14.9|            0.4|            69322| 17|
|Zambia                |                          13.9|            0.1|            25809| 17|
|Sao Tome and Principe |                          13.4|            0.0|              391| 16|
|Ukraine               |                          13.2|            0.6|           112154| 17|
|Ethiopia              |                          12.2|            0.4|            80561| 17|
|Iraq                  |                          12.2|            1.0|           197716| 12|
|Haiti                 |                          12.1|            0.0|             8408| 17|
|Ecuador               |                          12.0|            0.5|           103057| 17|
|Nigeria               |                          11.8|            1.9|           375771| 17|
|Russian Federation    |                          11.6|            8.1|          1577524| 17|
|Tajikistan            |                          11.2|            0.0|             7146| 16|
|Yemen, Rep.           |                          11.1|            0.1|            18213| 15|
|Romania               |                          10.7|            1.1|           211803| 17|
|Burundi               |                           9.9|            0.0|             3478| 17|
|Moldova               |                           9.7|            0.0|             8128| 17|
|Liberia               |                           9.6|            0.0|             2158| 15|
|Jamaica               |                           9.5|            0.1|            14768| 17|
|Kenya                 |                           9.5|            0.4|            74938| 17|
|Dominican Republic    |                           9.4|            0.4|            75932| 17|
|Madagascar            |                           9.2|            0.1|            11500| 17|
|Argentina             |                           9.1|            3.3|           637590| 14|
|Mongolia              |                           9.0|            0.1|            11488| 17|
|Mozambique            |                           8.9|            0.1|            12334| 17|
|Egypt, Arab Rep.      |                           8.7|            1.2|           235369| 17|
|Kazakhstan            |                           8.6|            0.8|           159407| 17|
|Sri Lanka             |                           8.5|            0.4|            87175| 17|
|Uruguay               |                           8.5|            0.3|            56157| 17|
|Pakistan              |                           8.0|            1.6|           304952| 17|




# Code 

The code is split into two parts: 

1. reading and cleaning 
2. seeing the relationships

Reading the data 

```R
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

saveRDS(df, file = "data/df.RDS")
```





Seeing the data 

```R
## read from web or disk 
read_web <- FALSE
if(read_web){source("read.R")}
if(!read_web){
df <- readRDS("data/df.RDS")
}

df

## plot 

# median inflation
median_infl_tot <- median(df$inflation, na.rm=TRUE)

# swe median 
df %>%
filter(country == "Sweden") %>%
filter(!is.na(inflation)) %>%
summarise(median(inflation))

# swe plot 
df %>%
filter(country == "Sweden") %>%
ggplot(aes(year, inflation)) + 
geom_smooth() + 
ggtitle("Sweden")

plotinf <- function(cntry, data=df){
data %>%
filter(country == cntry) %>%
ggplot(aes(year, inflation)) + 
geom_smooth() + 
ggtitle(cntry)
}

plotinfp <- function(cntry, data=df){
data %>%
filter(country == cntry) %>%
ggplot(aes(year, inflation)) + 
geom_point() +
geom_smooth() + 
ggtitle(cntry)
}


plotinf("United States")
plotinfp("Chile")

# us min max 
df %>%
filter(country == "United States") %>%
filter(!is.na(inflation)) %>%
summarise(max(inflation), min(inflation))

# outlier inflaiton 
df %>% 
filter(country == "Zimbabwe", year > 1999) %>%
summarise(mean(inflation, na.rm=TRUE))

# plot countries with high inflation
df %>%
filter(year > 1999) %>%
filter(!is.na(inflation)) %>%
group_by(country) %>%
mutate(mean_infl = mean(inflation)) %>%
filter(mean_infl > 15) %>%
filter(mean_infl < 1000) %>%
arrange(mean_infl) %>%
ggplot(aes(mean_infl, country)) + 
geom_point() +
ggtitle("Inflation (%) since year 1999")

# mean inflation (and nr of datapoints) 
df %>%
group_by(country) %>%
filter(!is.na(inflation)) %>%
filter(year > 1999) %>%
summarise(mean_infl = mean(inflation)) %>%
filter(mean_infl > 15) %>%
mutate(n = length(country))

# countries with high inflation
df %>%
filter(year > 1999) %>%
filter(!is.na(inflation)) %>%
group_by(country) %>%
summarise(mean_infl = mean(inflation), 
mean_gdp = mean(gdp),
mean_pop = mean(pop)
)

# gdp united states 
gdp_2017_us <- gdp_2017[gdp_2017$country == "United States", "gdp"]
gdp_2017_us <- as.numeric(gdp_2017_us)

# mean infl and gdp last 18y, for countries with high infl. 
tab_1 <- df %>%
group_by(country) %>%
filter(!is.na(inflation), !is.na(gdp)) %>% 
filter(year > 1999) %>%
mutate(n = length(year)) %>%
summarise_all(mean, na.rm=TRUE) %>%
select(country, inflation, n) %>%
arrange(desc(inflation)) %>%
filter(inflation > 8) %>%
mutate(inflation = round(inflation, 1)) %>%
rename(`Inflation (1999-2017 average)` = inflation)
tab_1
as.data.frame(tab_1)

# gdp per country 
tab_2 <- df %>%
group_by(country) %>%
fill(gdp) %>%
filter(year == 2017) %>%
select(country, gdp) %>%
ungroup() %>%
merge(tab_1, on="country") %>%
arrange(desc(`Inflation (1999-2017 average)`)) %>%
mutate(`GDP as % of US` = round(100* gdp / gdp_2017_us,1)) %>%
mutate(`GDP mUSD in 2017` = round(gdp / 10^6, 0)) %>%
select(-gdp)
names(tab_2)
tab_2 <- tab_2[, c(1,2,4,5,3)]
sum(tab_2$`GDP as % of US`)
sum(tab_2$`GDP mUSD in 2017`)

dim(tab_1)[1]
sum(tab_2$`GDP as % of US`)
conclusion_1 <- "42 countries have above 8 percent inflation (measured as CPI average 1999 to 2017)."
conclusion_2 <- "Their total gdp is 1/3 of the United States' GDP."

kable(tab_2)
```