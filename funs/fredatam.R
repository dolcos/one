fredatam <- function(var){
  query <- sprintf("RUNDEF Job SELECTION ALL TABLE t1 AS AREALIST OF BARRIO, BARRIO.CBARRIO, %s OMITTITLE DECIMALS 2", var)
  
  remDr$open()
  
  remDr$navigate(one.red)
  
  Sys.sleep(30)
  webElem <- remDr$findElement(using = 'name', value = "CMDSET")
  webSubm <- remDr$findElement(using = 'name', value = "SUBMIT")
  webElem$getElementAttribute("name")
  webSubm$getElementAttribute("name")
  webElem$sendKeysToElement(list(query, key = "enter"))
  webSubm$clickElement()
  
  Sys.sleep(30)
  # doc <- htmlParse(remDr$getPageSource()[[1]], encoding = "UTF-8")
  # tb0 <- getNodeSet(doc, "//table")
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
  
  remDr$close
  
  assign(tolower(var), doc.df)
}

# End()