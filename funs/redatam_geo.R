query_geo <- "RUNDEF Job SELECTION ALL TABLE t1 AS AREALIST OF BARRIO,
         REGION.IDREGION,
         REGION.CREGION,
         REGION.REGION,
         PROVIC.IDPROVI,
         PROVIC.CPROVINCIA,
         PROVIC.PROVIN,
         MUNIC.IDMUNI,
         MUNIC.CMUNICIPIO,
         MUNIC.MUNI,
         DISTR.IDDISTR,
         DISTR.CDISTRITO,
         DISTR.DISTRITO,
         ZONA.IDZONA,
         ZONA.CZONA,
         ZONA.ZONA,
         SECCION.IDSECCION,
         SECCION.CSECCION,
         SECCION.SECCION,
         BARRIO.IDBARRIO,
         BARRIO.CBARRIO,
         BARRIO.BARRIO         
         OMITTITLE DECIMALS 2"

remDr$open()

remDr$navigate(one.red)

Sys.sleep(30)
webElem <- remDr$findElement(using = 'name', value = "CMDSET")
webSubm <- remDr$findElement(using = 'name', value = "SUBMIT")
webElem$getElementAttribute("name")
webSubm$getElementAttribute("name")
webElem$sendKeysToElement(list(query_geo, key = "enter"))
webSubm$clickElement()

Sys.sleep(60)
# doc <- htmlParse(remDr$getPageSource()[[1]], encoding = "UTF-8")
# tb0 <- getNodeSet(doc, "//table")
doc <- read_html(remDr$getPageSource()[[1]], encoding = "UTF-8") %>% 
  html_nodes("table") %>% 
  html_table(fill = TRUE)
doc.df <- as.data.frame(doc[[1]])
names(doc.df) <- tolower(unlist(doc.df[2,]))
names(doc.df) <- unlist(lapply(names(doc.df), 
                               function(x) str_replace_all(x, "[[:punct:]]", "")))
names(doc.df) <- unlist(lapply(names(doc.df), 
                               function(x) str_replace_all(x, " ", "_")))
names(doc.df) <- unlist(lapply(names(doc.df), 
                               function(x) str_replace_all(x, "-", "_")))
names(doc.df) <- unlist(lapply(names(doc.df), 
                               function(x) stri_trans_general(x, "Latin-ASCII")))
doc.df <- doc.df[, -c(4, 7, 10, 13, 16, 19, 22)]
doc.df <- filter(doc.df, codigo != "")
doc.df <- doc.df[2:nrow(doc.df), ]

remDr$close

saveRDS(doc.df, file = "./data/ubigeo.rds")

# End()