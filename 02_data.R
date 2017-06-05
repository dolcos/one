one.red <- "http://redatam.one.gob.do/cgibin/RpWebEngine.exe/CmdSet?&BASE=CPV2010&ITEM=PROGRED&MAIN=WebServerMain.inl"

# 2 variables = 8 mins
system.time(
  etl.ls_cpv2010 <- lapply(etl.dicc_ls,  fredatam)
  )

etl.dicc_ls2 <- lapply(etl.dicc_ls, function(x) 
  str_replace(x, "[[:punct:]]", "_"))

etl.dicc_ls2 <- lapply(etl.dicc_ls2, tolower)

# for (i in seq(etl.ls_cpv2010))
#   assign(tolower(etl.dicc_ls2[[i]]), etl.ls_cpv2010[[i]])

names(etl.ls_cpv2010) <- etl.dicc_ls2

list2env(etl.ls_cpv2010 ,.GlobalEnv)

# dbWriteTable(con.mysql,
#              "hogar_h35", 
#              hogar_h35,
#              row.names = FALSE)
# 
# for(i in seq_along(etl.ls_cpv2010)){
# x <- names(etl.ls_cpv2010)[[i]]
# y <- etl.ls_cpv2010[[i]]
#    dbWriteTable(con.mysql,
#                 x,
#                 y,
#                 row.names = FALSE
#                 )
#    }

# dbListTables(con.mysql)

# End()