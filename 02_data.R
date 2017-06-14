one.red <- "http://redatam.one.gob.do/cgibin/RpWebEngine.exe/CmdSet?&BASE=CPV2010&ITEM=PROGRED&MAIN=WebServerMain.inl"

# Para variables con factor de menos de 10 niveles: 2 variables = 8 mins
system.time(
  etl.ls_cpv2010 <- lapply(etl.dicc_ls,  fredatam)
  )

# etl.dicc_ls2 <- lapply(etl.dicc_ls, function(x) 
#   str_replace(x, "[[:punct:]]", "_"))
# 
# etl.dicc_ls2 <- lapply(etl.dicc_ls2, tolower)
# 
# names(etl.ls_cpv2010) <- etl.dicc_ls2
# 
# list2env(etl.ls_cpv2010 ,.GlobalEnv)

# End()