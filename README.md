# Dynamic web scraping using Rselenium.

A helpful post in an earlier coder's corner post dealt with webscraping using rvest. Rvest allows you to scrape text and download files in static webpages, but RSelenium completes the webscraping toolkit, allowing you to actively interact with the webpages themselves. Let's say we need to input log-in details, select drop-down menus and even click next-page buttons - the RSelenium package is powerful enough for all of the above.

In this post, I showcase a small case study of using R to interact with a webpage, specifically the European Competition Authority's library of rulings. This task would be the challenge before scraping the website to download all relevant rulings of interest.

## Part I – Installing Docker

RSelenium works by operating a version of a internet browser that R can directly interact with. One of the easiest ways to create this virtual browser is through installing Docker[link]. Docker creates a virtual browser for Rselenium, and by extension us, to directly send commands to the browser. It also allows for our code to be reproducible and run bug-free, as we can specify exactly which browser version and type our code should run with.

After installing docker, using the command prompt to begin running the browser - 

```
docker run -d -p 4445:4444 selenium/standalone-firefox:2.53.0
```
For further help, refer directly to https://docs.ropensci.org/RSelenium/articles/docker.html.

