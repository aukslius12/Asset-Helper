## Prerequisites
import os
from os.path import join
import pandas as pd

## Locates local Chrome path and returns it.
# ISSUE 1: Only works for chrome. Universal browser would be awesome (useless now, but might be useful someday). Maybe get the default browser somehow?
# ISSUE 2: If we had a settings file, this would take waay less time than it requires now. If a settings file is implemented, this will need to be updated.
def LocateChromePath():
    lookfor = "chrome.exe"
    for root, dirs, files in os.walk('C:\\'):
        if lookfor in files:
            chrome_path = join(root, lookfor)
            break
    return(chrome_path)

## Opens website with local browser directory path, and webpage specified.
def OpenWebsite(path, webpage="www.google.com"):
    os.system(path + " %s" % webpage)

## Returns all financial statement urls out of a file and returns them in a dataframe.
def GetAllUrls ():
    path_file = os.getcwd()
    df_urls = pd.read_csv(path_file + '\\FinancialStatementData.csv')
    return(df_urls)

## Gets specified url of a financial statement out of GetALLUrls. Input is df from GetAllUrls()
# ISSUE: It would be great, if this returned the LAST quartely data, instead of user having to find it, open etc. This would be a relatively large project itself so it waaay into the future.
def OpenFinancialStatement (ticker_name = "AAPL"):
    # GetsDfUrls
    df_urls = GetAllUrls()
    # Find the url
    ticker_url = df_urls.loc[df_urls.ticker == ticker_name].url
    # Store as string (Also tests if there is a company within the data)
    try:
        ticker_url_str = ticker_url.values[0]
    except IndexError:
        print("There seems to be no company ticker named " + ticker_name + " in this dataframe.")
        return
    # Open website
    OpenWebsite(LocateChromePath(), ticker_url_str)
    return

# Testing
#OpenFinancialStatement()
#OpenFinancialStatement(ticker_name = "MSFT")
# Breaking code
#OpenFinancialStatement("TSLA")