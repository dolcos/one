# Base de datos plana CPV2010 redatam.one.gob.do ####    
one.red <- "http://redatam.one.gob.do/cgibin/RpWebEngine.exe/CmdSet?&BASE=CPV2010&ITEM=PROGRED&MAIN=WebServerMain.inl"

redatam <- "RUNDEF Job SELECTION ALL TABLE t1 AS AREALIST OF BARRIO, BARRIO.CBARRIO, HOGAR.H35 OMITTITLE DECIMALS 2"

remDr$open()
#remDr$getStatus()$build
#remDr$sessionInfo[c("version", "driverVersion")]

remDr$navigate(one.red)

Sys.sleep(60)

#remDr$refresh()

webElem <- remDr$findElement(using = 'name', value = "CMDSET")
webSubm <- remDr$findElement(using = 'name', value = "SUBMIT")
webElem$getElementAttribute("name")
webSubm$getElementAttribute("name")
webElem$sendKeysToElement(list(redatam, key = "enter"))
webSubm$clickElement()

# A mayor cantidad de variables hay que aumentar el tiempo de espera
Sys.sleep(120)
#webOne<-remDr$findElement(using = 'tag name', value = "table")
#webOne$getElementAttribute("tag name")

doc <- htmlParse(remDr$getPageSource()[[1]], encoding = "UTF-8")
                 
Sys.sleep(30)
                 
tb0 = getNodeSet(doc, "//table")
                 
tb1 = readHTMLTable(tb0[[1]], 
                 header = c("cod_barrio", "barrio", 
                 "muy_bajo", "bajo", 
                 "medio_bajo", "medio",
                 "medio_alto_alto", "total"),
                 trim = TRUE, stringsAsFactors = FALSE
                 )

tb1[,3:8] <- lapply(tb1[,3:8],
                 function(tb1){as.numeric(gsub(",", "", tb1))})
                 tb1 <- filter(tb1, is.na(total) == FALSE)
                 
remDr$close
                 
# End()