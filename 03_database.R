drv.jdbc <- JDBC("com.microsoft.sqlserver.jdbc.SQLServerDriver",
                   "~/sqljdbc_6.0/enu/sqljdbc4.jar")

con.jdbc <- dbConnect(drv.jdbc, 
  "jdbc:sqlserver://comunidad-analitica.database.windows.net:1433;databaseName=CensoRD",
  Sys.getenv("uid"), Sys.getenv("passmssql"))

# Read local data ####
path.tofix <- "./data/tofix"
path.fixed <- "./data/fixed"

rds.files <- list.files(path = path.fixed, 
                        pattern = "*.rds", 
                        full.names = TRUE, 
                        recursive = FALSE)

rds.names <- list.files(path = path.fixed, 
                        pattern = "*.rds", 
                        full.names = FALSE, 
                        recursive = FALSE)

rds.names2 <- lapply(rds.names, function(x) {
  str_replace_all(x, ".rds", "")})

rds.list <- lapply(rds.files, readRDS)

names(rds.list) <- rds.names2

# To clean (arreglar maximo length 100 p52c y ;) ####
# lapply(rds.names2, function(x) names(rds.list[[x]]))

for(x in rds.names2) { 
  # names(rds.list[[x]]) <- 
  #        str_replace_all(unlist(names(rds.list[[x]])), 
  #                        "\\.", "")
  # names(rds.list[[x]]) <- 
  #   str_replace_all(unlist(names(rds.list[[x]])), 
  #                   "\\,", "")
  names(rds.list[[x]]) <- 
    str_replace_all(unlist(names(rds.list[[x]])), 
                    "\\;", "")
  # names(rds.list[[x]]) <- 
  #   str_replace_all(unlist(names(rds.list[[x]])), 
  #                   "\\(a\\)", "_a")
  # names(rds.list[[x]]) <- 
  #   str_replace_all(unlist(names(rds.list[[x]])), 
  #                   "\\/", "_")
  # names(rds.list[[x]]) <-
  # ifelse(str_detect(names(rds.list[[x]]), "[[:digit:]]") == TRUE, 
  #        paste0("x", names(rds.list[[x]])), names(rds.list[[x]]))
  names(rds.list[[x]]) <-
    substr(names(rds.list[[x]]), 1, 100)
}

lapply(rds.names2, function(x) names(rds.list[[x]]))

lapply(rds.names2, function(x) saveRDS(rds.list[[x]], 
                                       paste0(path.fixed, "/", 
                                              x, ".rds")))

# Write to remote database ####
lapply(rds.names2, function(x) {
  dbWriteTable(con.jdbc, x, 
               rds.list[[x]], 
               overwrite = TRUE,
               row.names = FALSE
  )
})

# Read remote data #### 
tables <- as.data.frame(dbListTables(con.jdbc))
test0 <- dbGetQuery(con.jdbc, "select top 200 * from hogar_h35")

# Close connection ####
dbDisconnect(con.jdbc)

# End() ####