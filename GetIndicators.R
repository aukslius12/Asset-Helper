# Libraries
library(tidyverse)
library(quantmod)
library(lubridate)

#-------- Get Idicators Function ---------
# Input is self-explanatory
# Returns Annualized returns, volatility, and sharpe ratio. Also measures if there was a volume shift.


get_indicators <-
  function(stock_name,
           source = "google",
           indicator_period = "yearly",
           start = Sys.Date() - 365,
           end = Sys.Date()) {
    
    ## Testing for errors in input
    if (!source %in% c("google", "yahoo")){
      stop("Invalid source provided. Curretly supports google and yahoo finance.")
    }
    
    ## Set n based on indicator_period
    if (indicator_period == "yearly") {
      n_per <- 252
    } else if (indicator_period == "monthly") {
      n_per <- 12
    } else if (indicator_period == "weekly") {
      n_per <- 52
    } else if (indicator_period == "quartely") {
      n_per <- 4
    } else if (indicator_period == "daily") {
      n_per <- 1
    } else {
      stop(
        "Your indicator_period value is not yet supported. Currently supported periods are: yearly, monthly, weekly, quarterly, daily."
      )
    }
    
    ##  Loading data
    data_historical <-
      getSymbols(
        Symbols = stock_name,
        src = source,
        auto.assign = F,
        from = start,
        to = end
      )
    
    ## Periodized (Like annualized but sounding idiotic, yet robust) returns
    ret <-
      as.vector(mean(periodReturn(data_historical, period = indicator_period))) #ISSUE: This calculates for periods, e.g. years, and meanns the values (not the specified date period itself)
    
    ## Periodized Volatility
    vol <- sd(dailyReturn(data_historical)) * sqrt(n_per)
    
    ## Sharpe ratio
    sharpe <- ret / vol
    
    ## Calculating Volume Trend shift
    data_hist_vol <- tail(data_historical[, 4], 6)
    
    ## Logic: if last day volume is higher than 1 standart deviation than mean of 5 days before that, then there was a volume trend shift
    volatility_increase <-
      as.vector(ifelse(data_hist_vol[1] >= (
        mean(data_hist_vol[2:6]) + sd(data_hist_vol[2:6])
      ), T, F))
    
    ## Store and return results
    return(
      tibble(
        "Returns" = ret,
        "Volatility" = vol,
        "Sharpe ratio" = sharpe,
        "Volatility trend shift" = volatility_increase
      )
    )
  }

# Testing
#get_indicators("AAPL", source = "google", indicator_period = "yearly", start = Sys.Date() - 365, end = Sys.Date())
#get_indicators("AAPL")
