# Base de datos plana CPV2010 redatam.one.gob.do ####    
one.red <- "http://redatam.one.gob.do/cgibin/RpWebEngine.exe/CmdSet?&BASE=CPV2010&ITEM=PROGRED&MAIN=WebServerMain.inl"

redatam <- "RUNDEF Job SELECTION ALL TABLE t1 AS AREALIST OF BARRIO, BARRIO.CBARRIO, HOGAR.H35 OMITTITLE DECIMALS 2"

remDr$open()
#remDr$getStatus()$build
#remDr$sessionInfo[c("version", "driverVersion")]

remDr$navigate(one.red)

Sys.sleep(30)

#remDr$refresh()

webElem <- remDr$findElement(using = 'name', value = "CMDSET")
webSubm <- remDr$findElement(using = 'name', value = "SUBMIT")
webElem$getElementAttribute("name")
webSubm$getElementAttribute("name")
webElem$sendKeysToElement(list(redatam, key = "enter"))
webSubm$clickElement()

# A mayor cantidad de variables hay que aumentar el tiempo de espera
Sys.sleep(30)
#webOne<-remDr$findElement(using = 'tag name', value = "table")
#webOne$getElementAttribute("tag name")

doc <- read_html(remDr$getPageSource()[[1]], encoding = "UTF-8") %>% 
  html_nodes("table") %>% 
  html_table(fill = TRUE)

doc.df <- as.data.frame(doc[[1]])

names(doc.df) <- tolower(unlist(doc.df[2,]))
names(doc.df) <- unlist(lapply(names(doc.df), 
                        function(x) str_replace_all(x, " ", "_")))
names(doc.df) <- unlist(lapply(names(doc.df), 
                               function(x) str_replace_all(x, "-", "_")))
names(doc.df) <- unlist(lapply(names(doc.df), 
                               function(x) stri_trans_general(x, "Latin-ASCII")))

doc.df[,3:ncol(doc.df)] <- lapply(doc.df[,3:ncol(doc.df)],
                    function(doc.df){as.numeric(gsub(",", "", doc.df))})

doc.df <- filter(doc.df, is.na(total) == FALSE)

# doc <- htmlParse(remDr$getPageSource()[[1]], encoding = "UTF-8")
#                 
# tb0 <- getNodeSet(doc, "//table")
#                  
# tb1 <- readHTMLTable(tb0[[1]], 
#                  header = c("cod_barrio", "barrio", 
#                  "muy_bajo", "bajo", 
#                  "medio_bajo", "medio",
#                  "medio_alto_alto", "total"),
#                  trim = TRUE, stringsAsFactors = FALSE
#                  )
# 
# tb1[,3:8] <- lapply(tb1[,3:8],
#                  function(tb1){as.numeric(gsub(",", "", tb1))})
#                  tb1 <- filter(tb1, is.na(total) == FALSE)
                 
remDr$close
                 
# End()