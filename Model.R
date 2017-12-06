#Basic Idea
#Model for Finance Econ:
# 1. What do you want to know?
# 2. Get that data
# 3. Present the data
# 4. Gather articles about stock market in general
# 5. Gather articles about the asset
# 6. Present those articles
# 7. Interactive/real-time?
# 8. ?


#What indicators to get?
# 1. Sharpe
# 2. Volatility
# 3. PE
# 4. ?
# 5. Volume trend (last day)

#How?
# Function 1.Input is historical data and n-days, output is indicators + graph?

#Libraries
library(tidyverse)
library(quantmod)
library(lubridate)

#-------- Get Idicators Function ---------

#Input is historical stock data (XTS format) and n of days for indicator calculation (default = 250) 
#!! Currently supports only annual calculation (default n_days) !!
get_indicators <- function(data_hist, n_days = 250) {
  
  #Annual Return
  ret <- as.vector(annualReturn(data_hist))
  
  #Volatility
  vol <- sd(dailyReturn(data_hist))*sqrt(250)
  
  #PE ratio
  pe <- ret/vol
  
  #Selecting last six days
  data_hist_vol <- data_hist[nrow(data_hist):(nrow(data_hist) - 5),5]
  
  #Calculating Volume Trend
  volatility_increase <- as.vector(ifelse(data_hist_vol[1] >= mean(data_hist_vol[2:6]), T, F))
  
  #Store and return results
  return(
    tibble("Returns" = ret,
           "Volatility" = vol,
           "PE ratio" = pe,
           "Volatility trend increas" = volatility_increase)
  )
}

#Temp test data
spy <- getSymbols(Symbols = "SPY", src = "google", auto.assign = F, from = "2016-01-01", to = "2017-01-01")

get_indicators(spy)
