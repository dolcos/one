one.red <- "http://redatam.one.gob.do/cgibin/RpWebEngine.exe/CmdSet?&BASE=CPV2010&ITEM=PROGRED&MAIN=WebServerMain.inl"

etl.ls_cpv2010 <- lapply(etl.dicc_ls,  fredatam)

etl.dicc_ls2 <- lapply(etl.dicc_ls, function(x) 
  str_replace(x, "[[:punct:]]", "_"))

etl.dicc_ls2 <- lapply(etl.dicc_ls2, tolower)

# for (i in seq(etl.ls_cpv2010))
#   assign(tolower(etl.dicc_ls2[[i]]), etl.ls_cpv2010[[i]])

names(etl.ls_cpv2010) <- etl.dicc_ls2

list2env(etl.ls_cpv2010 ,.GlobalEnv)

do.call(function(x) dbWriteTable(con.mysql, etl.dicc_ls2[[x]], 
             value = as.data.frame, 
             row.names = FALSE), etl.ls_cpv2010)

# dbListTables(con.mysql)

# End()