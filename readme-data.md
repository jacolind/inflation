# about 

all data comes from world bank. downlaoded 2018-10-12. 

# gdp 

http://databank.worldbank.org/data/reports.aspx?source=2&series=NY.GDP.MKTP.CD#

# gdp per capita 

# R package 

https://cran.r-project.org/web/packages/WDI/WDI.pdf

syntax 

```
WDI(country = "all", indicator = "NY.GNS.ICTR.GN.ZS", 
    start = 2005, end = 2011, extra = FALSE, cache = NULL)
```

example 

```
> WDIsearch(string='gdp per capita', field='name')
      indicator             
 [1,] "GDPPCKD"             
 [2,] "GDPPCKN"             
 [3,] "NV.AGR.PCAP.KD.ZG"   
 [4,] "NY.GDP.PCAP.CD"      
 [5,] "NY.GDP.PCAP.KD"      
 [6,] "NY.GDP.PCAP.KD.ZG"   
 [7,] "NY.GDP.PCAP.KN"      
 [8,] "NY.GDP.PCAP.PP.CD"   
 [9,] "NY.GDP.PCAP.PP.KD"   
[10,] "NY.GDP.PCAP.PP.KD.ZG"
[11,] "SE.XPD.PRIM.PC.ZS"   
[12,] "SE.XPD.SECO.PC.ZS"   
[13,] "SE.XPD.TERT.PC.ZS"   
      name                                                                 
 [1,] "GDP per Capita, constant US$, millions"                             
 [2,] "Real GDP per Capita (real local currency units, various base years)"
 [3,] "Real agricultural GDP per capita growth rate (%)"                   
 [4,] "GDP per capita (current US$)"                                       
 [5,] "GDP per capita (constant 2000 US$)"                                 
 [6,] "GDP per capita growth (annual %)"                                   
 [7,] "GDP per capita (constant LCU)"                                      
 [8,] "GDP per capita, PPP (current international $)"                      
 [9,] "GDP per capita, PPP (constant 2005 international $)"                
[10,] "GDP per capita, PPP annual growth (%)"                              
[11,] "Expenditure per student, primary (% of GDP per capita)"             
[12,] "Expenditure per student, secondary (% of GDP per capita)"           
[13,] "Expenditure per student, tertiary (% of GDP per capita)" 
```