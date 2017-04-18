library(rvest)
library(RSelenium)
library(dplyr)

pJS <- phantom()
Sys.sleep(5) # give the binary a moment

one.url1 <- "http://redatam.one.gob.do/cgibin/RpWebEngine.exe/CmdSet?&BASE=CPV2010&ITEM=PROGRED&MAIN=WebServerMain.inl"
one.url2 <- read_html(one.url1)
redatam <- "RUNDEF Job SELECTION ALL TABLE t1 AS AREALIST OF BARRIO, BARRIO.CBARRIO, HOGAR.H09A, HOGAR.H09B, HOGAR.H09C, HOGAR.H09D, HOGAR.H09E, HOGAR.H09F, HOGAR.H09G, HOGAR.H09H, HOGAR.H09I, HOGAR.H09J OMITTITLE DECIMALS 2"

            HOGAR.H09K, HOGAR.H09L, HOGAR.H09M, HOGAR.H09N, 
            HOGAR.H09NN, HOGAR.H09O, HOGAR.H10, HOGAR.H11, 
            HOGAR.H12, HOGAR.H13, HOGAR.H14, HOGAR.H15, 
            HOGAR.H16, HOGAR.H17, HOGAR.H18, HOGAR.H25ACC, 
            HOGAR.H30, HOGAR.H31, HOGAR.H32, HOGAR.H35, 
            HOGAR.P27, HOGAR.P29, HOGAR.P38, HOGAR.H25AH,      
            HOGAR.H25BM, HOGAR.H25CT, HOGAR.P38AEST, HOGAR.PPI,        
            HOGAR.NPPI, HOGAR.GDEPN, HOGAR.MNP36      
            
            

# RSelenium
# RSelenium::checkForServer()
# RSelenium::startServer()
# system("java -jar /opt/selenium/selenium")

remDr <- remoteDriver(browserName = "phantomjs")

remDr$open()
#remDr$getStatus()$build
#remDr$sessionInfo[c("version", "driverVersion")]

remDr$navigate(one.url1)

Sys.sleep(60)

#remDr$refresh()

webElem<-remDr$findElement(using = 'name', value = "CMDSET")
webSubm<-remDr$findElement(using = 'name', value = "SUBMIT")
webElem$getElementAttribute("name")
webSubm$getElementAttribute("name")
webElem$sendKeysToElement(list(redatam, key = "enter"))
webSubm$clickElement()

# A mayor cantidad de variables hay que aumentar el tiempo de espera
Sys.sleep(120)
#webOne<-remDr$findElement(using = 'tag name', value = "table")
#webOne$getElementAttribute("tag name")

doc <- htmlParse(remDr$getPageSource()[[1]], encoding = "UTF-8")
                 
Sys.sleep(60)
                 
tb0 = getNodeSet(doc, "//table")
                 
tb1 = readHTMLTable(tb0[[1]], 
                 # header = c("cod_barrio", "barrio", 
                 # "muy_bajo", "bajo", 
                 # "medio_bajo", "medio",
                 # "medio_alto_alto", "total"),
                 trim = TRUE, stringsAsFactors = FALSE
                 )

tb1[,3:8] <- lapply(tb1[,3:8],
                 function(tb1){as.numeric(gsub(",", "", tb1))})
                 tb1 <- filter(tb1, is.na(total) == FALSE)
                 
remDr$close
pJS$stop() # close the PhantomJS process, note we dont call remDr$closeServer()
                 
# End()