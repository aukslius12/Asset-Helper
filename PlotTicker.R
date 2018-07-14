# Libraries
library(ggplot2)
library(dplyr)
library(gridExtra)

## Plots a graph of a specified ticker
PlotTicker <- function(stock_name = "AAPL",
                       source = "google",
                       indicator_period = "yearly",
                       start = Sys.Date() - 365,
                       end = Sys.Date()){
  
  ## Load prerequisites
  source_wd <- getwd()
  source(str_c(source_wd, "/GetIndicators.R"))
  
  ## Load data
  ticker_data <- GetIndicators(stock_name,
                               source,
                               indicator_period,
                               start,
                               end,
                               return_historical = TRUE)
  
  ## Changing names for clarity
  ticker_data_hist <- as.data.frame(ticker_data[2])
  colnames(ticker_data_hist) <- c("open", "high", "low", "close","volume")
  
  #Fuck this fucking shit what the fuck 
  ticker_plot <- a 
  ggplot(data = ticker_data_hist) +
    geom_line(aes(y = close, x = ticker_data_hist[,1]))
  
}
