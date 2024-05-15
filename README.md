# Dynamic web scraping using Rselenium

A helpful post in an earlier coder's corner post dealt with webscraping using rvest. Rvest allows you to scrape text and download files in static webpages, but RSelenium completes the webscraping toolkit, allowing you to actively interact with the webpages themselves. Let's say we need to input log-in details, select drop-down menus and even click next-page buttons - the RSelenium package is powerful enough for all of the above.

In this post, I showcase a small case study of using R to interact with a webpage, specifically the European Competition Authority's library of rulings. This task would be the challenge before scraping the website to download all relevant rulings of interest.

## Part I – Installing Docker



RSelenium works by operating a version of an internet browser that R can directly interact with. One of the easiest ways to create this virtual browser is through installing Docker[link]. Docker creates a virtual browser for Rselenium, and by extension us, to directly send commands to the browser. It also allows for our code to be reproducible and run bug-free, as we can specify exactly which browser version and type our code should run with.

After installing docker, using the command prompt to begin running the browser - 

```
docker run -d -p 4445:4444 selenium/standalone-firefox:2.53.0
```
For further help, refer directly to https://docs.ropensci.org/RSelenium/articles/docker.html.

## Part II – Setting up Rselenium

Having made a version of the browser within Docker, and after installing RSelenium, we connect RSelenium with the existing browser.


```
  
  # initialzing virtual environment

fprof <- makeFirefoxProfile(list(
  "pdfjs.disabled"=TRUE,
  "plugin.scan.plid.all"=FALSE,
  "plugin.scan.Acrobat" = "99.0",
  "browser.helperApps.neverAsk.saveToDisk"='application/pdf'))
# Open a firefox browser
remDr <- remoteDriver(remoteServerAddr = "localhost", port = 4445L, extraCapabilities = fprof )
remDr$open()


```
makefirefoxProfile lets us set some default behaviour of our virtual firefox browser. Also note that the Ports and browser correspond to the browser we created with Docker. 

To check if this worked, open a webpage in Rselenium using 

```
remDr$navigate("https://ec.europa.eu/competition/elojade/isef/index.cfm?clear=1&policy_area_id=1")

```

To see what R is seeing, let's take a screenshot and ask R to display the image. You should see a website with a search box as below:

```

remDr$screenshot(display = TRUE)

```

![image](https://github.com/csae-coders-corner/dyn-web-scrape/assets/64132992/5c115dc6-ccc1-48f1-97bb-3e46bb793457)


Now that we know that Rselenium can access the internet, we can move to interacting directly with the website using the retinue of commands that RSelenium puts at our disposal.




## Part II – Interacting with the webpage


Our goal is to set the search menu in the webpage to filter for all cartel cases in the database,  from 8-9-2007 to 8-9-2021. Additionaly we also want to input sector codes  and select specific document types. Let's look at the example code below where we attempt to filter to documents related to 'Cartels' from 2008 to 2020.


Step 1: To select 'Cartels' under policy area, we first need to select cartels under 'policy area'. How do we tell R which button to press? For that, we need to use the underyling HTML structure of the webpage. This is what you see when you click 'see page source' on most webpages.
![image](https://github.com/csae-coders-corner/dyn-web-scrape/assets/64132992/ce8a5aa5-a313-42d0-8c1f-3b82eda967fc)


While it's quite the hassle to identify the button from pure HTML, a much easier way to point R to the button is to use a browser extension that does the work for you. I use Selector gadget [https://selectorgadget.com] that identifies the selector when you point and click.


![image](https://github.com/csae-coders-corner/dyn-web-scrape/assets/64132992/7ea12515-b0dc-411b-a277-c3d9aa5c8815)


We've found that the selector is ".classRadioButton" and we can also trial-and-error to find that 'Cartels' is the fourth button in that class. The code below then selects the button


```
rsel <- remDr$findElements(using = "css", ".classRadioButton") 
rsel[[4]]$clickElement()  # click cartels


```


To filter documnets from 2008 to 2020, we will interact with the 'Decision date' inputs. Following the same process above,

```
morereviews <- remDr$findElement(using = "css", "#decision_date_from")
morereviews$sendKeysToElement(list("8/9/2008"))
morereviews <- remDr$findElement(using = "css", "#decision_date_to")
morereviews$sendKeysToElement(list("8/9/2020"))
```


clickElement and sendKeysToElement are only a few of the many options available in Rselenium to you, for the full catalogue visit https://cran.r-project.org/web/packages/RSelenium/RSelenium.pdf or stack exchange for trickier web elements.

Now we can use 
```
Sys.sleep(5) # gives the webpage time to load
remDr$screenshot(display = TRUE)

```
to check if all our desired options are selected, followed by

```
morereviews <- remDr$findElement(using = "css", ".submit:nth-child(6)")
morereviews$clickElement()
```

which finds and clicks the submit button.



From here, you can switch to static webscraping using rvest, to download the full list of documents. RSelenium can be used in tandem with rvest, for eg., to click next page after scraping data from each page with rvest.


