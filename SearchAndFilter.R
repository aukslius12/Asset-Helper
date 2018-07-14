# Libraries
library(dplyr)
library(readr)
library(stringr)
library(tibble)

#--------- SearchAndFilter Function ------------
# Input can be nothing or:
# parameters -  named vector (names must be exact), variable length is supported
# volatility/returns/sharpe_lower - can be specified to change default lower/higher than the value filtering
#
# Everything else is self explanatory.

SearchAndFilter <- function(parameters = c(
  "Volatility" = NA,
  "Returns" = NA,
  "Sharpe ratio" = NA,
  "Volume trend shift" = NA
),
volatility_lower = TRUE,#{
returns_lower = FALSE,#Checks if you want to see if volatility, returns, sharpe is lower or higher than specified parameter
sharpe_lower = FALSE,#}
source = "google",
indicator_period = "yearly",
start = Sys.Date() - 365,
end = Sys.Date()) {
  ## Testing for errors in input
  
  if (length(parameters) < 1) {
    stop("No parameters found")
  }
  
  ## Load required information
  source_wd <- getwd()
  snp_500 <- read_csv(str_c(source_wd, "/SNP 500 Companies.csv"))
  #ISSUE 1: If there was a change in this list after a revision, it becomes outdated. Loading from official data website would be optimal but takes too much time.
  #ISSUE 2:
  #something wrong with dates in AMT. Needs looking into
  #LMT, NWL, NBL page doesn't even exist lol.
  
  source(str_c(source_wd, "/GetIndicators.R"))
  
  #Initiating results tibble
  data_indicator <- tibble(
    "Returns" = numeric(),
    "Volatility" = numeric(),
    "Sharpe ratio" = numeric(),
    "Volume trend shift" = logical()
  )
  
  ## Get indicators on each stock
  options(warn = -1) #ISSUE: periodReturn spams warnings when removing NA's. Might be solving by rewriting a function which would fix two issues with one stone.
  for (ticker in snp_500$`Ticker symbol`) {
    #Sys.sleep(0.1) #Might be required if an extremely fast internet is present. Tested on 12 MBPS internet.
    data_indicator <-
      rbind(data_indicator,
            GetIndicators(ticker, source, indicator_period, start, end))
  }
  options(warn = 0)
  results <- as.tibble(cbind(snp_500, data_indicator))
  
  
  ## Initiating parameter names vector for further use
  parameters_names <- names(parameters)
  
  ## Method which does what the name implies - filters parameters based on input
  ParameterFilter <- function(parameters_name) {
    ## Tests if parameter name is correct (dunno, might fail somewhere, good practice)
    if (!any(parameters_name == c("volatility", "returns", "sharpe"))) {
      stop("Unknown parameter name specified in ParameterFilter.")
    }
    
    #Selects the required parameter name
    req_name <- switch(
      parameters_name,
      "volatility" = "Volatility",
      "returns" = "Returns",
      "sharpe" = "Sharpe ratio"
    )
    
    ## Checks on parameterName_lower value
    parameters_test_name <- str_c(parameters_name, "_lower")
    if (get(parameters_test_name)) {
      return(results %>%
               filter(get(req_name) < parameters[req_name]))
    } else {
      return(results %>%
               filter(get(req_name) > parameters[req_name]))
    }
  }
  
  ## Filtering data based on each parameter (if any)
  if (all(is.na(parameters))) {
    warning("No parameters specified - returning data without filtering")
    return(results)
  }
  
  ## Multiple tests for clearer code - could be done in a single for()
  
  ## Volatility
  if (any("Volatility" == parameters_names) && !is.na(parameters["Volatility"])) {
    results <- ParameterFilter("volatility")
  }
  
  ## Returns
  if (any("Returns" == parameters_names) && !is.na(parameters["Returns"])) {
    results <- ParameterFilter("returns")
  }
  
  ## Sharpe
  if (any("Sharpe ratio" == parameters_names) && !is.na(parameters["Sharpe ratio"])) {
    results <- ParameterFilter("sharpe")
  }
  
  ## Volume trend shift
  if (any("Volume trend shift" == parameters_names) && !is.na(parameters["Volume trend shift"])) {
    results <- results %>%
      filter(`Volume trend shift` == parameters["Volume trend shift"])
  }
  
  return(results)
}

#Testing
#SearchAndFilter()
#SearchAndFilter(parameters = c(
#    "Volatility" = 0.2,
#   "Returns" = 0.3,
#    "Sharpe ratio" = 1,
#    "Volume trend shift" = NA
# ),
# volatility_lower = FALSE)
# #Other parameters can be changed too (sharpe/returns). Default for space saving. (can be Tested in GetIndicators code)
