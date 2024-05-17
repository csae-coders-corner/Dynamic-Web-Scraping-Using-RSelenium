library(fs)
library(RSelenium)
library(rvest)
library(tidyverse)
library(janitor)





# initialzing virtual environment


fprof <- makeFirefoxProfile(list(
  "pdfjs.disabled"=TRUE,
  "plugin.scan.plid.all"=FALSE,
  "plugin.scan.Acrobat" = "99.0",
  "browser.helperApps.neverAsk.saveToDisk"='application/pdf'))
# Open a firefox browser
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, extraCapabilities = fprof )
remDr$open()




#Opening webpage

remDr$navigate("https://ec.europa.eu/competition/elojade/isef/index.cfm?clear=1&policy_area_id=1")  # load search page 

#Click cartels


rsel <- remDr$findElements(using = "css", ".classRadioButton")  # click cartels
rsel[[4]]$clickElement()


Sys.sleep(1) # time to load !


#Fill date filters:
rsel <- remDr$findElement(using = "css", "#decision_date_from")
rsel$sendKeysToElement(list("8/9/2008"))
rsel <- remDr$findElement(using = "css", "#decision_date_to")
rsel$sendKeysToElement(list("8/9/2020"))

Sys.sleep(1)

remDr$screenshot(display = TRUE)
#Click submit
rsel <- remDr$findElement(using = "css", ".submit:nth-child(6)") #click submit
rsel$clickElement()



