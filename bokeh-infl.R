library(rbokeh)

glimpse(df)

df_1 <- df %>%
  group_by(country) %>%
  mutate(pop_million = pop / 10^6) %>%
  select(-iso2c, -year) %>%
  summarise_all(mean, na.rm=TRUE)
df_1

figure() %>%
  ly_points(pop_million, inflation, data=df_1, 
            hover = c(country, inflation, pop_million)) %>%
  x_axis(log=TRUE) %>%
  y_axis(log=TRUE)
