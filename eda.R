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
plotinfp("Germany")
plotinf("Turkey")

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