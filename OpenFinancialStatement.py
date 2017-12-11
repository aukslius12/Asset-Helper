#data is TICK + URL
#input is TICKER, output is opening a browser with the TICKER's financial statement
#TODO: MAKE THIS INTO A CLASS

import os
from os.path import join

#Locates local Chrome path and returns it.
#ISSUE 1: Only works for chrome. Universal browser would be awesome (useless now, but might be useful someday). Maybe get the default browser somehow?
#ISSUE 2: If we had a settings file, this would take waay less time than it requires now. If a settings file is implemented, this will need to be updated.
def LocateChromePath():
    lookfor = "chrome.exe"
    for root, dirs, files in os.walk('C:\\'):
        if lookfor in files:
            chrome_path = join(root, lookfor)
            break
    return(chrome_path)

#Opens website with local browser directory path, and webpage specified.
def OpenWebsite(path, webpage="www.google.com"):
    os.system(path + " %s" % webpage)

#TODO: Returns all financial statement urls out of a file and returns them in a dataframe.
def GetAllUrls ():
    return(null)

#TODO: Gets specified url of a financial statement out of GetALLUrls (can be merged into one function if the code is clear enough)
def GetTickerUrl ():
    return(null)
