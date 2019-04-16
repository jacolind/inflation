# read
dfi <- read_csv("data/API_FP.CPI.TOTL.ZG_DS2_en_csv_v2_10134464.csv", skip = 3)
str(dfi)
# clean 
names(dfi) <- gsub(" ", "_", names(dfi))
names(dfi)
dfi <- dfi %>%
  select(-Indicator_Name, -Indicator_Code) %>%
  rename(country = Country_Name) %>%
  gather(year, inflation, -country, -Country_Code) %>%
  mutate(inflation = as.numeric(inflation), 
         year = as.Date(paste(year, "-01-01", sep="")))


# median inflation
median_infl_tot <- median(dfi$inflation, na.rm=TRUE)

# swe median 
dfi %>%
  filter(country == "Sweden") %>%
  filter(!is.na(inflation)) %>%
  summarise(median(inflation))

# swe plot 
dfi %>%
  filter(country == "Sweden") %>%
  ggplot(aes(year, inflation)) + 
  geom_smooth() + 
  ggtitle("Sweden")

infplot <- function(cntry){
  dfi %>%
    filter(country == cntry) %>%
    ggplot(aes(year, inflation)) + 
    geom_point() +
    geom_smooth() + 
    ggtitle(cntry)
}

infplot2 <- function(cntry){
  dfi %>%
    filter(country == cntry) %>%
    ggplot(aes(year, inflation)) + 
    geom_smooth() + 
    ggtitle(cntry)
}


infplot("United States")

# us min max 
dfi %>%
  filter(country == "United States") %>%
  filter(!is.na(inflation)) %>%
  summarise(max(inflation), min(inflation))

# countries with high inflation
dfi %>%
  group_by(country) %>%
  filter(!is.na(inflation)) %>%
  summarise(mean_inflation = mean(inflation)) %>%
  filter(mean_inflation > 30) %>%
  filter(mean_inflation < 1000) %>%
  arrange(mean_inflation) %>%
  ggplot(aes(mean_inflation, country)) +
  geom_point()

dfi %>%
  group_by(country) %>%
  filter(!is.na(inflation)) %>%
  filter(year > "2000-01-01") %>%
  summarise(mean_inflation = mean(inflation)) %>%
  filter(mean_inflation > 15) %>%
  mutate(n = length(country))

dfi %>%
  filter(country == "Chile", year > "2000-01-01")

infplot2("Angola")

# todo 
# intersect with world population and GDP per country to see fraction of gdp and worl pop that have high inflation. 


# error nedan! 
# 
# > dfi %>%
#   +   group_by(country) %>%
#   +   filter(!is.na(inflation)) %>%
#   +   filter(year > "2000-01-01") %>%
#   +   summarise(mean_inflation = mean(inflation)) %>%
#   +   filter(mean_inflation > 15) %>%
#   +   mutate(n = length(country))
# # A tibble: 13 × 3
# country mean_inflation     n
# <chr>          <dbl> <int>
#   1              Angola       36.07795    13
# 2             Belarus       24.10891    13
# 3    Congo, Dem. Rep.       39.50114    13
# 4        Country Name     2009.00000    13
# 5               Ghana       15.61724    13
# 6              Guinea       16.82523    13
# 7  Iran, Islamic Rep.       17.21098    13
# 8              Malawi       15.24251    13
# 9             Myanmar       15.85111    13
# 10        South Sudan       66.58831    13
# 11              Sudan       15.80362    13
# 12      Venezuela, RB       46.84273    13
# 13           Zimbabwe     1910.59734    13