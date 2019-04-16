


# fed data https://www.quantmod.com/documentation/getSymbols.FRED.html

mydata = Quandl("FRED/GDP")

mydata = Quandl("FRED/GDPPOT", 
                start_date="2005-01-03",end_date="2013-04-10",
                type="xts")
mydata
## plot ratio of nasdaq (or sp500) market cap to us gdp since 1990.
